class Api::V1::ListenSignalsController < Api::V1::BaseController
  before_action :get_brand, only: [:index, :show]
  before_action :get_listen_signal, only: [:show]
  before_action :ensure_user_can_get_signal_info, only: [:index, :show]
  before_action :ensure_user_can_get_listen_signal, only: [:show]

  def index
    render json: @brand.listen_signals, each_serializer: ListenSignalSerializer
  end

  def show
    render json: @listen_signal, serializer: ListenSignalSerializer
  end

  def templates
    render json: listen_signal_template_types
  end

  private

  def get_listen_signal
    @listen_signal = ListenSignal.find(params[:id])
  end

  def ensure_user_can_get_signal_info
    if current_user.brand_id != @brand.id
      raise ApiErrors::StandardError.new(
        message: 'Sorry, you are not authorized to perfom this action',
        status: 401,
      )
    end
  end

  def ensure_user_can_get_listen_signal
    if !@brand.listen_signal_ids.include?(@listen_signal.id)
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
