require 'rails_helper'
require 'shared/stripe'

describe Api::V1::SubscriptionsController, type: :controller do
  include_context 'stripe setup'

  let(:params) { {} }

  before do
    # Assume authenticated
    allow(controller).to receive(:authenticate_user!)
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'POST create' do
    before do
      params.merge!(
        email: 'test+1234@example.com',
        subscription_plan_id: basic_plan.id,
        stripe_token: stripe_token,
      )
    end
    context 'a valid response' do
      it 'responds with a 200' do
        post :create, params
        expect(response).to be_ok
      end

      it 'creates a subscription' do
        expect {
          post :create, params
        }.to change {
          user.brand.reload.subscription.try(:persisted?)
        }.from(nil).to(true)
      end

      it 'changes the email of the user' do
        og_email = user.email
        expect {
          post :create, params
        }.to change {
          user.reload.email
        }.from(og_email).to('test+1234@example.com')
      end
    end
  end
end
