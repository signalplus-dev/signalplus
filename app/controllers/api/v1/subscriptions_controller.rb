class Api::V1::SubscriptionsController < Api::V1::BaseController
  before_action :get_brand
  before_action :ensure_user_can_perform_action
  before_action :set_subscription, only: [:update]
  before_action :ensure_subscription_belongs_to_brand, only: [:update]

  def create
    subscription_plan = SubscriptionPlan.find(params[:subscription_plan_id])
    subscription = Subscription.subscribe!(
      @brand,
      subscription_plan,
      params[:stripe_token]
    )

    # The email comes in from stripe. Assume it's valid. Don't throw errors
    # if it is not.
    current_user.email = params[:email]
    current_user.save if current_user.valid?

    render json: subscription, serializer: SubscriptionSerializer
  end

  def update
    subscription_plan = SubscriptionPlan.find(params[:subscription_plan_id])
    @subscription.update!(subscription_plan)

    render json: @subscription, serializer: SubscriptionSerializer
  end

  private

  def set_subscription
    @subscription = @brand.subscription
  end

  def ensure_subscription_belongs_to_brand
    unless can_update_subscription?
      raise ApiErrors::StandardError.new(
        message: 'Sorry, you are not authorized to perfom this action',
        status: 401,
      )
    end
  end

  def can_update_subscription?
    return false unless @subscription
    return false unless !!params[:id].to_s[/^\d+$/]
    @subscription.id == params[:id].to_i
  end
end
