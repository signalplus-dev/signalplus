require 'rails_helper'
require 'shared/stripe'

describe TwitterResponseWorker do
  include_context 'create stripe plans'

  let(:worker)          { described_class.new }
  let(:identity)        { create(:identity) }
  let(:brand)           { identity.brand }
  let(:email)           { identity.user.email }
  let(:basic_plan)      { SubscriptionPlan.basic }
  let!(:listen_signal)  { create(:listen_signal, brand: brand, identity: identity) }
  let!(:response_group) { create(:response_group_with_responses, listen_signal: listen_signal) }
  let(:tweet)           { example_twitter_tweet }
  let(:filter)          { Responders::Twitter::Filter.new(brand, tweet) }
  let(:response_hash)   { filter.grouped_replies.first.last.first.as_json }
  let(:client_user)     { double(:user, screen_name: 'SomeBrand') }
  let(:mock_client)     { double(:client, user: client_user) }
  let(:image)           { double(:image_file) }
  let(:image_string_io) { StringIO.new('some_image.png') }
  let(:temp_file)       { Tempfile.new('test.txt') }

  before do
    Subscription.subscribe!(brand, basic_plan, email, stripe_helper.generate_card_token)
    allow(Brand).to receive(:find_with_trackers).and_return(brand)
    allow(brand).to receive(:twitter_rest_client).and_return(mock_client)
    allow_any_instance_of(TempImage).to receive(:file).and_return(temp_file)
    allow_any_instance_of(TempImage).to receive(:image_string_io).and_return(image_string_io)
  end

  context 'not update tracker' do
    it 'records the tweet response' do
      expect(mock_client).to receive(:update).once.and_return(double(:tweet, id: 100))
      expect(TimelineHelper).to_not receive(:update_tracker!)
      expect {
        worker.perform(brand.id, response_hash)
      }.to change {
        TwitterResponse.count
      }.from(0).to(1)
    end
  end

  context 'with a Twitter::Error' do
    let(:mock_reply) { double(:reply) }

    before do
      allow(Responders::Twitter::Reply).to receive(:build)
        .with(brand: brand, as_json: response_hash).and_return(mock_reply)
    end

    context 'not a rate limit error' do
      before do
        allow(mock_reply).to receive(:respond!).and_raise(Twitter::Error::InternalServerError)
      end

      it 'should still raise the error' do
        expect {
          worker.perform(brand.id, response_hash)
        }.to raise_error(Twitter::Error::InternalServerError)
      end

      it 'should check if we are being rate limited' do
        expect(worker).to receive(:rate_limit_check)
        expect {
          worker.perform(brand.id, response_hash)
        }.to raise_error(Twitter::Error::InternalServerError)
      end

      it 'should not sleep' do
        expect(worker).to_not receive(:sleep)
        expect {
          worker.perform(brand.id, response_hash)
        }.to raise_error(Twitter::Error::InternalServerError)
      end
    end

    context 'a rate limit error' do
      let(:seconds_to_wait) { 10.minutes.from_now.to_i }
      let(:error) do
        Twitter::Error::TooManyRequests.new(
          'Too many requests',
          { 'x-rate-limit-reset' => seconds_to_wait.to_s },
          Twitter::Error::Code::RATE_LIMIT_EXCEEDED
        )
      end

      before do
        allow(mock_reply).to receive(:respond!).and_raise(error)
      end

      it 'will try to sleep' do
        expect(worker).to receive(:sleep)
        expect {
          worker.perform(brand.id, response_hash)
        }.to raise_error(Twitter::Error::TooManyRequests)
      end
    end
  end
end
