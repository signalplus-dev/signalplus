class DashboardController < ApplicationController
  respond_to :json

  before_action :check_current_user, only: [:index]

  def index
  end

  def support
  end

  def contact
  end

  def about
    # Need to provide subsription plan details
    @plan_types = [1,2,3,4]
  end

  private

  def get_signal_type_text(signal_type)
    case signal_type
      when ListenSignal::Types::OFFER
        'Send a special offer every time a follower sends a custom hashtag'
      when ListenSignal::Types::TODAY
        'Send a summary of your location or event each day a follower uses a custom hashtag'
      when ListenSignal::Types::CONTEST
        'Run a contest for your followers for a specific date range'
      when ListenSignal::Types::REMINDER
        'Send a reminder on a specific date to users when they use a custom hashtag'
    end
  end

  def check_current_user
    redirect_to root_path unless current_user
  end
end
