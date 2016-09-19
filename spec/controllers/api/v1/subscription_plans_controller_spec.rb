require 'rails_helper'

describe Api::V1::SubscriptionPlansController, type: :controller do
  describe 'GET /api/v1/subscription_plans' do
    before do
      create(:subscription_plan)
      allow(controller).to receive(:authenticate_user!)
      get :index
    end

    subject { JSON.parse(response.body).with_indifferent_access }

    its([:subscription_plans]) { is_expected.to have(1).items }

    it { expect(subject[:subscription_plans].first).to have_key(:id) }
    it { expect(subject[:subscription_plans].first).to include(name: 'Basic') }
    it { expect(subject[:subscription_plans].first).to include(description: 'Local Brands') }
    it { expect(subject[:subscription_plans].first).to include(currency_symbol: '$') }
    it { expect(subject[:subscription_plans].first).to include(number_of_messages: 5000) }
    it { expect(subject[:subscription_plans].first).to include(amount: 2900) }
  end
end
