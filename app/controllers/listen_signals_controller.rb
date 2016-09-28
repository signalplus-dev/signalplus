class ListenSignalsController < ApplicationController
  def edit_signal
    @signal = current_user.brand.listen_signals.where(name: signal_params[:name]).first

    update_signal(@signal, signal_params)
    update_responses(@signal, signal_params['firstResponse'], signal_params['repeatResponse'])

    flash[:success] = "Alert:  #{@signal.name} signal updated!"
    render json: {
      signal: @signal.to_json,
      responses: @signal.responses.to_json
    }
  end

  def create_template_signal
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
      flash[:success] = "Alert:  #{@signal.name} signal created!"
      render json: {
        signal: @signal.to_json,
        responses: @signal.responses.to_json
      }
    else
      flash[:error] = 'Alert:  Please fill out missing fields'
    end
  end

  private

  def update_signal(signal_attr)
    @signal.update_attributes!(signal_attr)
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

  def signal_params
    params.permit(:signalType, :name, :firstResponse, :repeatResponse, :active, :expirationDate)
  end
end
