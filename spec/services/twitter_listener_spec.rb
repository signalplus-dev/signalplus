require 'rails_helper'

describe TwitterListener do
  # @param hashtags [Array] an array of hashtags
  def create_mock_tweet(hashtags)
    double(
      :tweet,
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
    let(:mock_client) { double(:client) }
    let(:image)       { double(:image_file) }

    before do
      described_class.stub(:client).and_return(mock_client)
      File.stub(:open).and_return(image)
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
