require 'rails_helper'

describe Webhooks::BaseController, type: :request do
  describe 'POST /webhooks/stripe/invoices' do
    context 'invalid stripe event type' do
      it 'returns 400 response status with nothing' do
        post '/webhooks/stripe/invoices', params: { type: 'invalid.type'}
        expect(response.status).to eq(400)
        expect(response.body).to be_blank
      end
    end
  end
end

