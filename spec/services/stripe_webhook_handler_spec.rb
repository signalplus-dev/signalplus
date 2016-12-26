require 'rails_helper'

describe StripeWebhookHandler do
  context 'a valid handler class' do
    it 'should call StripeWebhook::InvoiceHandler#created' do
      event = double(:event, type: 'invoice.created')
      handler = described_class.new(event)
      expect_any_instance_of(StripeWebhook::InvoiceHandler).to receive(:send).with(:created)
      handler.handle_webhook
    end

    it 'should call StripeWebhook::InvoiceHandler#payment_succeeded' do
      event = double(:event, type: 'invoice.payment_succeeded')
      handler = described_class.new(event)
      expect_any_instance_of(StripeWebhook::InvoiceHandler).to receive(:send).with(:payment_succeeded)
      handler.handle_webhook
    end

    it 'should call StripeWebhook::Customer::SubscriptionHandler#deleted' do
      event = double(:event, type: 'customer.subscription.deleted')
      handler = described_class.new(event)
      expect_any_instance_of(StripeWebhook::Customer::SubscriptionHandler)
        .to receive(:send).with(:deleted)
      handler.handle_webhook
    end

    it 'should not call a non-existent method' do
      event = double(:event, type: 'invoice.foo_bar')
      handler = described_class.new(event)
      expect_any_instance_of(StripeWebhook::InvoiceHandler).to_not receive(:send).with(:foo_bar)
      handler.handle_webhook
    end
  end

  context 'an invalid handler class' do
    let(:bad_event) { event = double(:event, type: 'charge.success') }

    it 'should not raise an error' do
      expect { described_class.new(bad_event).handle_webhook }.to_not raise_error
    end

    it 'should not try to instantiate a new handler' do
      handler = described_class.new(bad_event)
      expect(handler).to_not receive(:new_handler)
      handler.handle_webhook
    end
  end
end
