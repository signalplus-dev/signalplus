require 'rails_helper'

describe PostPromotionalTweet do
  let(:identity)          { create(:identity) }
  let(:brand)             { identity.brand }
  let(:listen_signal)     { create(:listen_signal, brand: brand, identity: identity) }
  let(:promotional_tweet) { create(:promotional_tweet, listen_signal: listen_signal) }

  describe '#send!' do

    context 'without image' do
      let(:image) { nil }

      it 'returns promo tweet with id and timestamp' do
        allow_any_instance_of(PostPromotionalTweet).to receive(:post_tweet).and_return('1234567')
        post_service = PostPromotionalTweet.new(promotional_tweet, image, brand)

        expect {
          post_service.send!
        }.to change{
          promotional_tweet.reload.tweet_id
          promotional_tweet.reload.posted_at
        }
      end
    end

    # context 'with image' do
    #   let(:image) { }

    #   it 'returns promo tweet with id and timestamp' do
    #     allow_any_instance_of(PostPromotionalTweet).to receive(:post_tweet_with_image).and_return('1234567')
    #    PostPromotionalTweet.new(promotional_tweet, image, brand)
    #     expect {
    #       post_service.send!
    #     }.to change{
    #       promotional_tweet.reload.tweet_id
    #       promotional_tweet.reload.posted_at
    #     }
    #   end

    # end
  end
end
