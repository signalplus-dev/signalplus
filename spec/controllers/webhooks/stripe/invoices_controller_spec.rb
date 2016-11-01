require 'rails_helper'
require 'shared/stripe'

describe Webhooks::Stripe::InvoicesController, type: :controller do
  describe 'POST create' do
    before(:each) {
      allow(controller).to receive(:authenticate).and_return(true)
    }

    context 'invalid stripe event type' do
      before { post :create, params: { type: 'invalid.type' }}

      it 'returns 200 response status with nothing' do
        expect(response.status).to eq(200)
        expect(response.body).to be_blank
        expect(InvoiceHandler).not_to receive(:new)
      end
    end

    context 'valid stripe event type' do
      let(:event) { StripeMock.mock_webhook_event('invoice.created') }
      before { StripeMock.start }
      after { StripeMock.stop }

      it 'returns 200 response status with nothing' do
        allow(controller).to receive(:get_event_data).and_return(event.data.object)
        post :create, params: { type: StripeWebhookEvents::VALUES[0] }

        expect(response.status).to eq(200)
        expect(response.body).to be_blank
        expect(InvoiceHandler).to receive(:new)
      end
    end
  end
end

