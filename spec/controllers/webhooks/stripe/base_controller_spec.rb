require 'rails_helper'

describe Webhooks::Stripe::BaseController do
  describe 'POST /webhooks/stripe', type: :request do
    before do
      allow(ENV).to receive(:[]).and_return(nil)
      allow(ENV).to receive(:[]).with('STRIPE_WEBHOOK_USER').and_return('okayuser')
      allow(ENV).to receive(:[]).with('STRIPE_WEBHOOK_PW').and_return('rightpw')
    end

    context 'invalid stripe basic auth crendentials' do
      it 'returns 401 response with invalid credentials' do
        credentials = ActionController::HttpAuthentication::Basic.encode_credentials('wrong', 'noteven')
        post '/webhooks/stripe', headers: { 'HTTP_AUTHORIZATION' => credentials }
        expect(response.status).to eq(401)
      end
    end

    context 'valid stripe basic auth credentials' do
      it 'returns 200 response without calling stripe_error' do
        credentials = ActionController::HttpAuthentication::Basic.encode_credentials('okayuser', 'rightpw')
        post '/webhooks/stripe', headers: { 'HTTP_AUTHORIZATION' => credentials }
        expect(response.status).to eq(200)
        expect(response.body).to be_blank
      end
    end
  end

  describe 'POST index' do
    before do
      StripeMock.start
      allow(controller).to receive(:authenticate).and_return(true)
    end

    after { StripeMock.stop }

    context 'invalid stripe event type' do
      before do
        event = StripeMock.mock_webhook_event('customer.created')
        allow(Stripe::Event).to receive(:retrieve).and_return(event)
        post :index, params: { type: 'customer.created' }
      end

      it 'returns 200 response status with nothing' do
        expect(response.status).to eq(200)
        expect(response.body).to be_blank
        expect(StripeWebhookHandler).to_not receive(:new)
      end
    end

    context 'valid stripe event type' do
      let(:brand) { create(:brand) }
      let(:event) { StripeMock.mock_webhook_event('invoice.created') }

      before do
        allow(Stripe::Event).to receive(:retrieve).and_return(event)
        allow_any_instance_of(StripeWebhook::InvoiceHandler).to receive(:get_brand_id).and_return(brand.id)
      end

      it 'returns 200 response status with nothing' do
        post :index, params: { type: 'invoice.created' }

        expect(response.status).to eq(200)
        expect(response.body).to be_blank
      end

      it 'should create an invoice' do
        expect {
          post :index, params: { type: 'invoice.created' }
        }.to change {
          Invoice.count
        }.from(0).to(1)
      end
    end
  end
end
