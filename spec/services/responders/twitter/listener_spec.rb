require 'rails_helper'
require 'shared/stripe'

def incrementor
  @incrementor ||= 1
  @incrementor += 1
end

class TweetDouble < RSpec::Mocks::Double; end
class DirectMessageDouble < RSpec::Mocks::Double; end

describe Responders::Twitter::Listener do
  include_context 'create stripe plans'

  let(:user)            { double(:user, screen_name: 'Bobby') }
  let(:identity)        { create(:identity) }
  let(:brand)           { identity.brand }
  let(:email)           { identity.user.email }
  let(:basic_plan)      { SubscriptionPlan.basic }
  let!(:listen_signal)  { create(:listen_signal, brand: brand, identity: identity) }
  let!(:response_group) { create(:default_group_responses, listen_signal: listen_signal) }

  before do
    Subscription.subscribe!(brand, basic_plan, email, stripe_helper.generate_card_token)
    expect(Rollbar).to_not receive(:error)
  end

  # @param hashtags [Array] an array of hashtags
  def create_mock_tweet(hashtags = [])
    tweet = TweetDouble.new(
      :tweet,
      id:   incrementor,
      user: user,
      hashtags: hashtags.map do |hashtag|
        double(:hashtag, text: hashtag)
      end
    )
    stub_for_case_equality(tweet)
    tweet
  end

  def create_mock_direct_messages(hashtags)
    dm = DirectMessageDouble.new(
      :direct_message,
      id:   incrementor,
      sender: user,
      hashtags: hashtags.map do |hashtag|
        double(:hashtag, text: hashtag)
      end
    )
    stub_for_case_equality(dm)
    dm
  end

  def stub_for_case_equality(mock_message)
    case mock_message
    when TweetDouble
      allow(Twitter::Tweet).to receive(:===).and_return(false)
      allow(Twitter::Tweet).to receive(:===).with(mock_message).and_return(true)
    when DirectMessageDouble
      allow(Twitter::DirectMessage).to receive(:===).and_return(false)
      allow(Twitter::DirectMessage).to receive(:===).with(mock_message).and_return(true)
    end
  end

  def create_filter(mock_messages)
    filter = Responders::Twitter::Filter.new(brand, mock_messages)
    filter.out_multiple_requests!
    filter.out_users_already_replied_to!
  end

  let(:client_user)     { double(:user, screen_name: 'SomeBrand') }
  let(:mock_client)     { double(:client, user: client_user) }
  let(:temp_image)      { double(:image_file) }
  let(:image_string_io) { StringIO.new('some_image.png') }
  let(:temp_file)       { Tempfile.new('test.txt') }
  let(:file)            { double(:file, close: nil) }

  before do
    Sidekiq::Testing.inline!
    allow(TempImage).to receive(:new).and_return(temp_image)
    allow(temp_image).to receive(:file).and_return(temp_file)
    allow(temp_image).to receive(:image_string_io).and_return(image_string_io)
    allow_any_instance_of(Responders::Twitter::Reply)
      .to receive(:file_and_temp_image).and_return([file, temp_image])
    allow_any_instance_of(Brand).to receive(:twitter_rest_client).and_return(mock_client)
  end

  after { Sidekiq::Testing.disable! }

  describe '.process_messages' do
    before { allow_any_instance_of(Brand).to receive(:twitter_rest_client).and_return(mock_client) }

    let(:tweet) { example_twitter_tweet }
    let(:dm)    { example_twitter_direct_message }

    context 'just tweets' do
      context 'with no messages to reply to' do
        before do
          allow(mock_client).to receive(:direct_messages_received).and_return([])
          allow(mock_client).to receive(:mentions_timeline).and_return([])
        end

        it 'replies to messages' do
          expect(described_class).to receive(:reply_to_messages)
          described_class.process_messages(brand.id)
        end

        it 'does not update the tweet tracker' do
          expect {
            described_class.process_messages(brand.id)
          }.to_not change {
            brand.tweet_tracker.reload
          }
        end

        it 'does not update the dm tracker' do
          expect {
            described_class.process_messages(brand.id)
          }.to_not change {
            brand.twitter_dm_tracker.reload
          }
        end
      end

      context 'with messages to reply to' do
        context 'replying to tweets' do
          before do
            allow(mock_client).to receive(:direct_messages_received).and_return([])
            allow(mock_client).to receive(:mentions_timeline).and_return([tweet])
            allow_any_instance_of(Response).to receive(:has_image?).and_return(true)
          end

          it 'updates the since_id of the tweet tracker' do
            expect(mock_client).to receive(:update_with_media).with(
              a_kind_of(String),
              file
            ).and_return(tweet)

            expect {
              described_class.process_messages(brand.id)
            }.to change {
              brand.tweet_tracker.reload.since_id
            }
          end

          it 'updates the last_recorded_tweet_id of the tweet tracker' do
            expect(mock_client).to receive(:update_with_media).with(
              a_kind_of(String),
              file
            ).and_return(tweet)

            expect {
              described_class.process_messages(brand.id)
            }.to change {
              brand.tweet_tracker.reload.last_recorded_tweet_id
            }
          end
        end
      end
    end
  end

  describe '.reply_to_messages' do
    context 'replying with an image' do
      before do
        allow_any_instance_of(Response).to receive(:has_image?).and_return(true)
      end

      let(:grouped_replies) do
        create_filter(create_mock_tweet(['somehashtag'])).grouped_replies
      end

      it 'replies with an image' do
        expect(mock_client).to receive(:update_with_media).and_return(create_mock_tweet)
        described_class.send(:reply_to_messages, grouped_replies, brand)
      end

      context 'not replying to tweets already replied to in the same day' do
        let(:more_grouped_replies) do
          create_filter(create_mock_tweet(['somehashtag'])).grouped_replies
        end

        let(:even_more_grouped_replies) do
          create_filter(create_mock_tweet(['somehashtag'])).grouped_replies
        end

        before { stub_current_time(Time.current) }

        context 'trying to request a deal on the same day' do
          before do
            expect(mock_client).to receive(:update_with_media).twice.with(
              a_kind_of(String),
              file
            ).and_return(create_mock_tweet)

            expect {
              described_class.send(:reply_to_messages, grouped_replies, brand)
            }.to change { TwitterResponse.count }.from(0).to(1)
          end

          it 'replies with a repeat response' do
            expect {
              described_class.send(:reply_to_messages, more_grouped_replies, brand)
            }.to change { TwitterResponse.count }.from(1).to(2)
            expect(TwitterResponse.last.response_id).to eq(response_group.repeat_response.id)
          end

          it 'does not respond after a repeat response' do
            described_class.send(:reply_to_messages, more_grouped_replies, brand)

            expect {
              described_class.send(:reply_to_messages, even_more_grouped_replies, brand)
            }.to_not change { TwitterResponse.count }
          end
        end

        context 'requesting a deal on a different day' do
          before do
            expect(mock_client).to receive(:update_with_media).twice.and_return(create_mock_tweet)
            expect {
              described_class.send(:reply_to_messages, grouped_replies, brand)
            }.to change { TwitterResponse.count }.from(0).to(1)
          end

          it 'does reply to a hashtag on a different day' do
            stub_current_time(1.day.from_now)
            allow(TempImage).to receive(:new).and_return(temp_image)
            allow(temp_image).to receive(:file).and_return(Tempfile.new('test.txt'))
            expect {
              described_class.send(:reply_to_messages, more_grouped_replies, brand)
            }.to change { TwitterResponse.count }.from(1).to(2)
          end
        end
      end
    end

    context 'replying without an image' do
      let(:grouped_replies) do
        create_filter(create_mock_tweet(['somehashtag'])).grouped_replies
      end

      it 'replies without an image' do
        expect(mock_client).to receive(:update).and_return(create_mock_tweet)
        described_class.send(:reply_to_messages, grouped_replies, brand)
      end
    end

    context 'replying only to the dm and not the tweet' do
      let(:mixed_grouped_replies) do
        mock_messages = [
          create_mock_direct_messages(['somehashtag']),
          create_mock_tweet(['somehashtag']),
        ]

        create_filter(mock_messages).grouped_replies
      end

      it 'only replies once' do
        expect(mock_client).to receive(:update).once.and_return(create_mock_tweet)
        described_class.send(:reply_to_messages, mixed_grouped_replies, brand)
      end

      it 'creates a twitter response record for just the direct message' do
        allow(mock_client).to receive(:update).and_return(create_mock_tweet)
        expect {
          described_class.send(:reply_to_messages, mixed_grouped_replies, brand)
        }.to change {
          TwitterResponse.direct_messages.count
        }.from(0).to(1)
      end

      it 'updates the twitter response with the tweet id' do
        allow(mock_client).to receive(:update).and_return(create_mock_tweet)
        described_class.send(:reply_to_messages, mixed_grouped_replies, brand)
        expect(TwitterResponse.first.reply_tweet_id).to_not be_nil
      end
    end
  end
end
