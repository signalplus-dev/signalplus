require 'rails_helper'

def incrementor
  @incrementor ||= 1
  @incrementor += 1
end

describe TwitterListener do
  let(:user) { double(:user, screen_name: 'Bobby') }
  # @param hashtags [Array] an array of hashtags
  def create_mock_tweet(hashtags)
    double(
      :tweet,
      id:   incrementor,
      user: user,
      hashtags: hashtags.map do |hashtag|
        create_mock_hashtag(hashtag)
      end
    )
  end

  def create_mock_hashtag(hashtag_text)
    double(:hashtag, attrs: { text: hashtag_text })
  end

  describe '.get_tweets_to_respond_to' do
    subject { described_class.send(:get_tweets_to_respond_to, tweets) }

    context 'no hash tags' do
      let(:tweets) do
        [
          create_mock_tweet([])
        ]
      end

      it { is_expected.to be_empty }
    end

    context 'with hashtags that are not being listened to' do
      let(:tweets) do
        [
          create_mock_tweet(['notlistening'])
        ]
      end

      it { is_expected.to be_empty }
    end

    context 'with hastags that are being listened to' do
      context 'with one tweet' do
        let(:tweets) do
          [
            create_mock_tweet(['somehashtag'])
          ]
        end

        it { is_expected.to_not be_empty }
      end

      context 'with 2 tweets' do
        let(:tweets) do
          [
            create_mock_tweet(['notlistening']),
            create_mock_tweet(['somehashtag']),
          ]
        end

        it         { is_expected.to_not be_empty }
        its(:size) { is_expected.to eq(1) }
      end
    end
  end

  describe '.respond_to_tweets' do
    let(:client_user)     { double(:user, screen_name: 'SomeBrand') }
    let(:mock_client)     { double(:client, user: client_user) }
    let(:image)           { double(:image_file) }
    let(:image_string_io) { StringIO.new('some_image.png') }
    let(:temp_file)       { Tempfile.new('test.txt') }

    before do
      allow(described_class).to           receive(:user_context_client).and_return(mock_client)
      allow_any_instance_of(TempImage).to receive(:file).and_return(temp_file)
      allow_any_instance_of(TempImage).to receive(:image_string_io).and_return(image_string_io)
    end

    context 'responding with an image' do
      let(:tweets_to_respond_to) do
        described_class.send(
          :get_tweets_to_respond_to,
          [create_mock_tweet(['somehashtag'])]
        )
      end

      it 'responds with an image' do
        expect(mock_client).to receive(:update_with_media)
        described_class.send(:respond_to_tweets, tweets_to_respond_to)
      end

      context 'not responding to tweets already responded to in the same day' do
        let(:more_tweets_to_respond_to) do
          described_class.send(
            :get_tweets_to_respond_to,
            [create_mock_tweet(['somehashtag'])]
          )
        end

        before { stub_current_time(Time.current) }

        context 'trying to request a deal on the same day' do
          before do
            expect(mock_client).to receive(:update_with_media).once
            expect {
              described_class.send(:respond_to_tweets, tweets_to_respond_to)
            }.to change { TwitterResponse.count }.from(0).to(1)
          end

          it 'does not respond twice to the same hashtag on the same day' do
            expect {
              described_class.send(:respond_to_tweets, more_tweets_to_respond_to)
            }.not_to change { TwitterResponse.count }
          end
        end

        context 'requesting a deal on a different day' do
          before do
            expect(mock_client).to receive(:update_with_media).twice
            expect {
              described_class.send(:respond_to_tweets, tweets_to_respond_to)
            }.to change { TwitterResponse.count }.from(0).to(1)
          end

          it 'does respond to a hashtag on a different day' do
            stub_current_time(1.day.from_now)
            allow_any_instance_of(TempImage).to receive(:file).and_return(Tempfile.new('test.txt'))
            expect {
              described_class.send(:respond_to_tweets, more_tweets_to_respond_to)
            }.to change { TwitterResponse.count }.from(1).to(2)
          end
        end
      end
    end

    context 'responding without an image' do
      let(:tweets_to_respond_to) do
        described_class.send(
          :get_tweets_to_respond_to,
          [create_mock_tweet(['somehashtagwithoutimage'])]
        )
      end

      it 'responds without an image' do
        expect(mock_client).to receive(:update)
        described_class.send(:respond_to_tweets, tweets_to_respond_to)
      end
    end
  end
end
