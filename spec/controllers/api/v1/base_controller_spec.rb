require 'rails_helper'

describe Api::V1::BaseController, type: :request do
  let(:password)     { 'password' }
  let(:user)         { create(:user, password: password, password_confirmation: password) }
  let(:base_headers) { { CONTENT_TYPE: 'application/json' }}
  let(:sign_in_data) { { email: user.email, password: password } }


  describe 'POST /api/v1/auth/sign_in' do
    context 'creating tokens' do
      it 'creates a devise api auth token' do
        expect(user.tokens).to be_empty
        post '/api/v1/auth/sign_in', params: sign_in_data.to_json, headers: base_headers
        expect(user.reload.tokens).to_not be_empty
      end
    end

    context 'the response' do
      before        { post '/api/v1/auth/sign_in', params: sign_in_data.to_json, headers: base_headers }
      subject       { response }
      its(:headers) { is_expected.to have_key('access-token') }
      its(:headers) { is_expected.to have_key('client') }
      its(:headers) { is_expected.to have_key('uid') }
      its(:headers) { is_expected.to have_key('expiry') }
    end
  end

  describe 'DELETE /api/v1/auth/sign_out' do
    before do
      post '/api/v1/auth/sign_in', params: sign_in_data.to_json, headers: base_headers
      @auth_creds = response.headers
                     .slice('access-token', 'client', 'uid', 'expiry')
                     .merge('token-type' => 'Bearer')
    end

    it 'removes the token' do
      expect {
        delete '/api/v1/auth/sign_out', headers: base_headers.merge(@auth_creds)
      }.to change { user.reload.tokens }
    end
  end

  describe 'GET test' do
    context 'an authorized user' do
      before do
        post '/api/v1/auth/sign_in', params: sign_in_data.to_json, headers: base_headers
        @auth_creds = response.headers
                       .slice('access-token', 'client', 'uid', 'expiry')
                       .merge('token-type' => 'Bearer')
      end

      context 'no server error' do
        it 'can successfully access a protected endpoint if authorized' do
          get '/api/v1/test', headers: base_headers.merge(@auth_creds)
          expect(response).to be_ok
          expect(response.body).to eq('ok')
        end

        context 'the headers of the response' do
          before        { get '/api/v1/test', headers: base_headers.merge(@auth_creds) }
          subject       { response }
          its(:headers) { is_expected.to have_key('access-token') }
          its(:headers) { is_expected.to have_key('client') }
          its(:headers) { is_expected.to have_key('uid') }
          its(:headers) { is_expected.to have_key('expiry') }
        end

        context 'an expired token' do
          before do
            new_expiry = 1.minute.ago.to_i
            @auth_creds['expiry'] = new_expiry
            client_id = user.reload.tokens.keys.first
            user.tokens[client_id]['expiry'] = new_expiry
            user.save
          end

          it 'does something' do
            get '/api/v1/test', headers: base_headers.merge(@auth_creds)
            expect(response).to be_unauthorized
          end
        end
      end
    end

    context 'a non authorized user' do
      it 'responds with an unauthorized status' do
        get '/api/v1/test', headers: base_headers
        expect(response).to be_unauthorized
      end
    end
  end
end
