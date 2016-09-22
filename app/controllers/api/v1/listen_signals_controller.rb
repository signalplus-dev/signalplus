class Api::V1::ListenSignalsController < Api::V1::BaseController
  before_action :get_brand, only: [:index]
  before_action :ensure_user_can_get_signal_info, only: [:index]

  def index
    render json: @brand.listen_signals, each_serializer: ListenSignalSerializer
  end

  def templates
    render json: listen_signal_template_types
  end

  private

  def ensure_user_can_get_signal_info
    if current_user.brand_id != @brand.id
      raise ApiErrors::StandardError.new(
        message: 'Sorry, you are not authorized to perfom this action',
        status: 401,
      )
    end
  end

  def listen_signal_template_types
    {
      templates: {
        ListenSignal::Types::OFFER => 'Send a special offer every time a follower sends a custom hashtag',
        ListenSignal::Types::TODAY => 'Send a summary of your location or event each day a follower uses a custom hashtag',
        ListenSignal::Types::CONTEST => 'Run a contest for your followers for a specific date range',
        ListenSignal::Types::REMINDER => 'Send a reminder on a specific date to users when they use a custom hashtag',
      }
    }
  end
end
