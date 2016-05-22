require 'rails_helper'

describe Streamers::Twitter do
  let(:identity)        { create(:identity) }
  let(:brand)           { identity.brand }
  let!(:listen_signal)  { create(:listen_signal, brand: brand, identity: identity) }
  let!(:response_group) { create(:response_group_with_responses, listen_signal: listen_signal) }

  describe '#initialize' do
    context 'with both trackers' do
      it 'initializes without complaining' do
        expect { described_class.new(brand.reload) }.not_to raise_error
      end
    end

    context 'with one of the trackers missing' do
      it 'raises an error when there is no associated tweet tracker' do
        brand.tweet_tracker.destroy
        expect { described_class.new(brand.reload) }.to raise_error(StandardError)
      end

      it 'raises an error when there is no associated dm tracker' do
        brand.twitter_dm_tracker.destroy
        expect { described_class.new(brand.reload) }.to raise_error(StandardError)
      end
    end
  end

  describe '#process_message' do
    let(:streamer)         { described_class.new(brand) }
    let(:brand_twitter_id) { 10 }

    before do
      # Assume we have a saved twitter oauth identity
      allow(brand).to receive(:twitter_id).and_return(brand_twitter_id)
    end

    context 'a tweet' do
      let(:message) { example_twitter_tweet }

      context 'with a tweet from the brand' do
        let(:mock_user) { double(:user, id: brand_twitter_id) }
        before { allow(message).to receive(:user).and_return(mock_user) }

        it 'does not process the message' do
          expect(Responders::Twitter::Filter).to_not receive(:new)
          streamer.send(:process_message, message)
        end
      end

      context 'with a tweet that is not from the brand' do
        before do
          expect(Responders::Twitter::Filter).to receive(:new).and_call_original
        end

        context 'with no signals that are being listened to' do
          before do
            allow(message).to receive(:hashtags).and_return([])
          end

          it 'does not process the message' do
            expect(TwitterResponseWorker).to_not receive(:perform_async)
            streamer.send(:process_message, message)
          end
        end

        context 'with signals that are being listened to' do
          it 'processes the message' do
            expect(TwitterResponseWorker).to receive(:perform_async)
            streamer.send(:process_message, message)
          end
        end
      end
    end

    context 'a direct message' do
      let(:message) { example_twitter_direct_message }

      context 'with a direct message from the brand' do
        let(:mock_sender) { double(:sender, id: brand_twitter_id) }
        before { allow(message).to receive(:sender).and_return(mock_sender) }

        it 'does not process the message' do
          expect(Responders::Twitter::Filter).to_not receive(:new)
          streamer.send(:process_message, message)
        end
      end

      context 'with a direct message that is not from the brand' do
        before do
          expect(Responders::Twitter::Filter).to receive(:new).and_call_original
        end

        context 'with no signals that are being listened to' do
          before do
            allow(message).to receive(:hashtags).and_return([])
          end

          it 'does not process the message' do
            expect(TwitterResponseWorker).to_not receive(:perform_async)
            streamer.send(:process_message, message)
          end
        end

        context 'with signals that are being listened to' do
          it 'processes the message' do
            expect(TwitterResponseWorker).to receive(:perform_async)
            streamer.send(:process_message, message)
          end
        end
      end
    end
  end
end
