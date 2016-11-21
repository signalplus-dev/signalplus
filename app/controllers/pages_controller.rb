class PagesController < ApplicationController
  include HighVoltage::StaticPage

  before_action :set_data_to_render_route

  private

  def set_data_to_render_route
    case params[:id]
    when 'home'
      set_home_data
    end
  end

  def set_home_data
    # Need to provide subsription plan details
    subscriptionPlans = ActiveModelSerializers::SerializableResource.new(SubscriptionPlan.all).as_json
    @subscription_plans_props = {
      inDashboard: false,
      hasExistingSubscription: false,
      subscriptionPlans: subscriptionPlans[:subscription_plans],
    }
  end
end
