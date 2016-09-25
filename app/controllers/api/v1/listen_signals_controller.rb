class Api::V1::ListenSignalsController < Api::V1::BaseController
  before_action :get_brand, only: [:index, :show]
  before_action :get_listen_signal, only: [:show]
  before_action :ensure_user_can_get_signal_info, only: [:index, :show]
  before_action :ensure_user_can_get_listen_signal, only: [:show]

  def update
    @signal = current_user.brand.listen_signals.where(name: signal_params[:name]).first

    update_signal(@signal, signal_params)
    update_responses(@signal, signal_params['firstResponse'], signal_params['repeatResponse'])

    flash[:success] = "Alert:  #{@signal.name} signal updated!"
    render json: {
      signal: @signal.to_json,
      responses: @signal.responses.to_json
    }
  end

  def create
    @brand = current_user.brand
    @identity = @brand.identities.first

    name = signal_params['name']
    signal_type = signal_params['signalType']
    first_response = signal_params['firstResponse']
    repeat_response = signal_params['repeatResponse']
    exp_date = signal_params['expirationDate']

    @signal = ListenSignal.create_signal(@brand, @identity, name, signal_type, exp_date)
    create_template_response(@signal, first_response, repeat_response, exp_date)

    if @signal
      render json: {
        signal: @signal.to_json,
        responses: @signal.responses.to_json
      }
    else
      flash[:error] = 'Alert:  Please fill out missing fields'
    end
  end

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

  def update_signal(signal, params)
    signal_attr = {
      name: params['name'],
      active: params['active'],
      expiration_date: params['expirationDate']
    }
    signal.update_attributes(signal_attr)
  end

  def update_responses(signal, first_msg, repeat_msg)
    signal.first_response.update_message(first_msg)
    signal.repeat_response.update_message(repeat_msg)
  end

  def create_template_response(signal, first_response, repeat_response, exp_date)
    response_group = ResponseGroup.create(listen_signal_id: signal.id)
    Response.create_response(first_response, 1, Response::Type::FIRST, response_group, exp_date)
    Response.create_response(repeat_response, 2, Response::Type::REPEAT, response_group, exp_date)
  end
end
