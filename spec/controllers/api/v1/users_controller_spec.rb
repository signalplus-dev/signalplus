require 'rails_helper'

describe Api::V1::UsersController, type: :controller do
  let(:user)  { create(:identity).user }
  let(:brand)         { user.brand }

  before do
    allow(controller).to receive(:authenticate_user!).and_return(nil)
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'GET show' do
    before { get :show, params: { id: user.id } }

    context 'the status' do
      it 'responds with a 200' do
        expect(response).to be_ok
      end
    end

    context 'the json response' do
      subject { JSON.parse(response.body).with_indifferent_access }

      it { is_expected.to have_key(:user) }

      its([:user]) { is_expected.to include(id: user.id) }
      its([:user]) { is_expected.to include(email: user.email) }
      its([:user]) { is_expected.to include(email_subscription: user.email_subscription) }
      its([:user]) { is_expected.to have_key(:brand) }

      it 'should only have 4 keys' do
        expect(subject[:user].keys.length).to eq(4)
      end
    end
  end

  describe 'POST update' do
    context 'a valid update request' do
      let(:user_update_params) do
        {
          email: 'test@example.com',
          email_subscription: !user.email_subscription,
        }
      end

      let(:brand_update_params) { { tz: 'America/New_York' } }

      context 'with user info to update' do
        it 'responds with a 200' do
          post :update, params: { id: user.id, user: user_update_params }
          expect(response).to be_ok
        end

        it 'updates the email of the user' do
          expect {
            post :update, params: { id: user.id, user: user_update_params }
          }.to change {
            user.reload.email
          }.from('test@signal.me').to('test@example.com')
        end

        it 'updates the email subscription of the user' do
          expect {
            post :update, params: { id: user.id, user: user_update_params }
          }.to change {
            user.reload.email_subscription
          }.from(false).to(true)
        end
      end

      context 'with both user and brand info to update' do
        let(:params) { { id: user.id, user: user_update_params, brand: brand_update_params } }

        it 'responds with a 200' do
          post :update, params: params
          expect(response).to be_ok
        end

        it 'updates the brand' do
          expect {
            post :update, params: params
          }.to change {
            brand.reload.tz
          }.from(nil).to('America/New_York')
        end
      end
    end

    context 'an invalid update request' do
      context 'with no user params' do
        it 'responds with a 400' do
          post :update, params: { id: user.id, user: {} }
          expect(response.status).to eq(400)
        end
      end
    end
  end
end
