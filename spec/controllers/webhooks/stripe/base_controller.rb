require 'rails_helper'

describe Webhooks::Stripe::BaseController do
  describe 'POST /webhooks/stripe/invoices', type: :request do
    context 'invalid stripe basic auth crendentials' do
      it 'returns 200 response through stripe_error' do
        credentials = ActionController::HttpAuthentication::Basic.encode_credentials('wrong', 'noteven')
        @request.env['HTTP_AUTHORIZATION'] = credentials

        post '/webhooks/stripe/invoices'
        expect(response.status).to eq(401)
      end
    end

    context 'valid stripe basic auth credentials', type: :request do
      it 'returns 200 response without calling stripe_error' do

        # Please stub a default value first if message might be received with other args as well.???
        # allow(ENV).to receive(:[]).with('STRIPE_WEBHOOK_USER').and_return('okayuser')
        # allow(ENV).to receive(:[]).with('STRIPE_WEBHOOK_PW').and_return('rightpw')

        credentials = ActionController::HttpAuthentication::Basic.encode_credentials('okayuser', 'rightpw')
        @request.env['HTTP_AUTHORIZATION'] = credentials

        post '/webhooks/stripe/invoices'

        expect(response.status).to eq(200)
        expect(response.body).to be_blank
      end
    end

  end
end

