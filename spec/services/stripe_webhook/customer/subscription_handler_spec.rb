require 'rails_helper'
require 'shared/stripe'

describe StripeWebhook::Customer::SubscriptionHandler do
  include_context 'stripe mock create subscription'

  let(:subscription) { brand.reload.subscription }

  describe '#deleted' do
    let(:event) { StripeMock.mock_webhook_event('customer.subscription.deleted') }

    before do
      allow(Subscription).to receive(:find_by!).and_return(subscription)
    end

    subject { described_class.new(event) }

    context 'deactivated subscription' do
      let(:canceled_time)    { 4.days.ago.change(usec: 0) }
      let(:deactivated_time) { 1.day.ago.change(usec: 0) }

      before do
        subscription.update!(
          canceled_at: canceled_time,
          will_be_deactivated_at: deactivated_time,
        )
      end

      it 'should not try to deactivate the subscription' do
        expect {
          subject.deleted
        }.to_not change {
          subscription.reload.will_be_deactivated_at
        }.from(deactivated_time)
      end

      it 'should not to try to mark the subscription as canceled' do
        expect {
          subject.deleted
        }.to_not change {
          subscription.reload.canceled_at
        }.from(canceled_time)
      end
    end

    context 'non-canceled subscription' do
      let(:current_time) { Time.current.change(usec: 0) }

      before { stub_current_time(current_time) }

      it 'should try to deactivate the subscription' do
        expect {
          subject.deleted
        }.to change {
          subscription.reload.will_be_deactivated_at
        }.from(nil).to(current_time)
      end

      it 'should to try to mark the subscription as canceled' do
        expect {
          subject.deleted
        }.to change {
          subscription.reload.canceled_at
        }.from(nil).to(current_time)
      end
    end

    context 'canceled but waiting to be deactivated subscription' do
      let(:canceled_time)    { 4.days.ago.change(usec: 0) }
      let(:deactivated_time) { 1.day.from_now.change(usec: 0) }
      let(:current_time)     { Time.current.change(usec: 0) }

      before do
        subscription.update!(
          canceled_at: canceled_time,
          will_be_deactivated_at: deactivated_time,
        )
        stub_current_time(current_time)
      end

      it 'should try to deactivate the subscription' do
        expect {
          subject.deleted
        }.to change {
          subscription.reload.will_be_deactivated_at
        }.from(deactivated_time).to(current_time)
      end

      it 'should to try to mark the subscription as canceled' do
        expect {
          subject.deleted
        }.to_not change {
          subscription.reload.canceled_at
        }.from(canceled_time)
      end
    end
  end
end
