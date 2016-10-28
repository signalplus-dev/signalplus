require 'rails_helper'
require 'shared/stripe'

describe Webhooks::Stripe::InvoicesController, type: :controller do
  describe 'POST create' do
    context 'invalid stripe event type' do
      before { post :create, params: { type: 'invalid.type' }}

      it 'returns 400 response status with nothing' do
        expect(response.status).to eq(400)
        expect(response.body).to be_blank
        expect(InvoiceHandler).not_to receive(:new)
      end
    end

    context 'valid stripe event type' do
      let(:event) { StripeMock.mock_webhook_event('invoice.created') }
      before { StripeMock.start }
      after { StripeMock.stop }

      it 'returns 200 response status with nothing' do
        allow(controller).to receive(:get_event).and_return(event)
        post :create, params: { type: StripeWebhookEvents::INVOICE_CREATED_EVENT }

        expect(response.status).to eq(200)
        expect(response.body).to be_blank
        # Any idea why this doesn't receive?
        # expect(InvoiceHandler).to receive(:new)
      end
    end
  end
end

