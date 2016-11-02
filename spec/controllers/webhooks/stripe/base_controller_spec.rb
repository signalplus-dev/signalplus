require 'rails_helper'

describe Webhooks::Stripe::BaseController, type: :request do
  describe 'POST /webhooks/stripe/invoices' do
    before do
      allow(ENV).to receive(:[]).and_return(nil)
      allow(ENV).to receive(:[]).with('STRIPE_WEBHOOK_USER').and_return('okayuser')
      allow(ENV).to receive(:[]).with('STRIPE_WEBHOOK_PW').and_return('rightpw')
    end

    context 'invalid stripe basic auth crendentials' do
      it 'returns 200 response through stripe_error' do
        credentials = ActionController::HttpAuthentication::Basic.encode_credentials('wrong', 'noteven')
        post '/webhooks/stripe/invoices', headers: { 'HTTP_AUTHORIZATION' => credentials }
        expect(response.status).to eq(401)
      end
    end

    context 'valid stripe basic auth credentials' do
      it 'returns 200 response without calling stripe_error' do
        credentials = ActionController::HttpAuthentication::Basic.encode_credentials('okayuser', 'rightpw')
        post '/webhooks/stripe/invoices', headers: { 'HTTP_AUTHORIZATION' => credentials }
        expect(response.status).to eq(200)
        expect(response.body).to be_blank
      end
    end

  end
end

