require 'rails_helper'

def incrementor
  @incrementor ||= 1
  @incrementor += 1
end

class TweetDouble < RSpec::Mocks::Double; end
class DirectMessageDouble < RSpec::Mocks::Double; end

describe Responders::Twitter::Listener do
  let(:brand) { create(:brand) }
  let(:user)  { double(:user, screen_name: 'Bobby') }

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
    filter.out_users_already_responded_to!
  end

  describe '.respond_to_messages' do
    let(:client_user)     { double(:user, screen_name: 'SomeBrand') }
    let(:mock_client)     { double(:client, user: client_user) }
    let(:image)           { double(:image_file) }
    let(:image_string_io) { StringIO.new('some_image.png') }
    let(:temp_file)       { Tempfile.new('test.txt') }

    before do
      allow_any_instance_of(TempImage).to receive(:file).and_return(temp_file)
      allow_any_instance_of(TempImage).to receive(:image_string_io).and_return(image_string_io)
    end

    context 'responding with an image' do
      let(:grouped_responses) do
        create_filter(create_mock_tweet(['somehashtag'])).grouped_responses
      end

      it 'responds with an image' do
        expect(mock_client).to receive(:update_with_media).and_return(create_mock_tweet)
        described_class.send(:respond_to_messages, grouped_responses, mock_client)
      end

      context 'not responding to tweets already responded to in the same day' do
        let(:more_grouped_responses) do
          create_filter(create_mock_tweet(['somehashtag'])).grouped_responses
        end

        before { stub_current_time(Time.current) }

        context 'trying to request a deal on the same day' do
          before do
            expect(mock_client).to receive(:update_with_media).once.and_return(create_mock_tweet)
            expect {
              described_class.send(:respond_to_messages, grouped_responses, mock_client)
            }.to change { TwitterResponse.count }.from(0).to(1)
          end

          it 'does not respond twice to the same hashtag on the same day' do
            expect {
              described_class.send(:respond_to_messages, more_grouped_responses, mock_client)
            }.not_to change { TwitterResponse.count }
          end
        end

        context 'requesting a deal on a different day' do
          before do
            expect(mock_client).to receive(:update_with_media).twice.and_return(create_mock_tweet)
            expect {
              described_class.send(:respond_to_messages, grouped_responses, mock_client)
            }.to change { TwitterResponse.count }.from(0).to(1)
          end

          it 'does respond to a hashtag on a different day' do
            stub_current_time(1.day.from_now)
            allow_any_instance_of(TempImage).to receive(:file).and_return(Tempfile.new('test.txt'))
            expect {
              described_class.send(:respond_to_messages, more_grouped_responses, mock_client)
            }.to change { TwitterResponse.count }.from(1).to(2)
          end
        end
      end
    end

    context 'responding without an image' do
      let(:grouped_responses) do
        create_filter(create_mock_tweet(['somehashtagwithoutimage'])).grouped_responses
      end

      it 'responds without an image' do
        expect(mock_client).to receive(:update).and_return(create_mock_tweet)
        described_class.send(:respond_to_messages, grouped_responses, mock_client)
      end

    end

    context 'responding only to the dm and not the tweet' do
      let(:mixed_grouped_responses) do
        mock_messages = [
          create_mock_direct_messages(['somehashtagwithoutimage']),
          create_mock_tweet(['somehashtagwithoutimage']),
        ]

        create_filter(mock_messages).grouped_responses
      end

      it 'only responds once' do
        expect(mock_client).to receive(:update).once.and_return(create_mock_tweet)
        described_class.send(:respond_to_messages, mixed_grouped_responses, mock_client)
      end

      it 'creates a twitter response record for just the direct message' do
        allow(mock_client).to receive(:update).and_return(create_mock_tweet)
        expect {
          described_class.send(:respond_to_messages, mixed_grouped_responses, mock_client)
        }.to change {
          TwitterResponse.direct_messages.count
        }.from(0).to(1)
      end

      it 'updates the twitter response with the tweet id' do
        allow(mock_client).to receive(:update).and_return(create_mock_tweet)
        described_class.send(:respond_to_messages, mixed_grouped_responses, mock_client)
        expect(TwitterResponse.first.tweet_id).to_not be_nil
      end
    end
  end
end
