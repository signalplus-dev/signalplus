require 'rails_helper'

describe PostPromotionalTweet do
  let(:identity)          { create(:identity) }
  let(:brand)             { identity.brand }
  let(:listen_signal)     { create(:listen_signal, brand: brand, identity: identity) }
  let(:message)           { 'blah blah' }
  let(:tweet)             { double('tweet') }

  describe '#send!' do

    context 'without image' do
      let(:image) { nil }

      it 'returns promo tweet with id and timestamp' do
        allow_any_instance_of(PostPromotionalTweet).to receive(:post_tweet).and_return(tweet)
        allow(tweet).to receive(:id).and_return('123456789')

        post_service = PostPromotionalTweet.new(message, image, listen_signal.id, brand)
        promo_tweet = post_service.send!
        expect(promo_tweet).to be_a PromotionalTweet
        expect(promo_tweet.tweet_id).to eq('123456789')
      end
    end
  end
end
