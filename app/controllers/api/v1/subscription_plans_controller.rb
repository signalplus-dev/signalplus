class Api::V1::SubscriptionPlansController < Api::V1::BaseController
  skip_around_action :set_time_zone

  def index
    render json: SubscriptionPlan.all, each_serializer: SubscriptionPlanSerializer
  end
end
