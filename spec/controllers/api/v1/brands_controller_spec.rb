require 'rails_helper'

describe Api::V1::BrandsController, type: :controller do
  let(:allowed_user)  { create(:identity).user }
  let(:brand)         { allowed_user.brand }

  before do
    allow(controller).to receive(:authenticate_user!).and_return(nil)
    allow(controller).to receive(:current_user).and_return(allowed_user)
  end

  describe 'GET show' do
    context 'a valid, authorized request' do
      context 'with a subscription' do
        let!(:subscription)  { create(:subscription, brand_id: brand.id) }
        before { get :show, id: brand.id }

        context 'the status' do
          it 'responds with a 200' do
            expect(response).to be_ok
          end
        end

        context 'the json response' do
          subject { JSON.parse(response.body).with_indifferent_access }

          it { is_expected.to have_key(:brand) }

          its([:brand]) { is_expected.to include(id: brand.id) }
          its([:brand]) { is_expected.to include(name: brand.name) }
          its([:brand]) { is_expected.to have_key(:subscription) }

          it { expect(subject[:brand][:subscription]).to include(id: subscription.id) }
          it {
            expect(subject[:brand][:subscription]).to include(subscription_plan_id: subscription.subscription_plan_id)
          }
        end
      end

      context 'without a subscription' do
        before { get :show, id: brand.id }

        subject { JSON.parse(response.body).with_indifferent_access }

        its([:brand]) { is_expected.to have_key(:subscription) }

        it { expect(subject[:brand][:subscription]).to be_nil }
      end
    end
  end
end
