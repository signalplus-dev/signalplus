class Api::V1::SubscriptionPlansController < Api::V1::BaseController
  def index
    render json: SubscriptionPlan.all, each_serializer: SubscriptionPlanSerializer
  end
end
