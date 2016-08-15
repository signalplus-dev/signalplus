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

    @signal = create_signal(@brand, @identity, name, signal_type, exp_date)
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

    def update_signal(signal, params)
      signal_attr = {
        name: params['name'],
        active: params['active'],
        expiration_date: params['expirationDate']
      }
      signal.update_attributes(signal_attr)
    end

    def update_responses(signal, first_msg, repeat_msg)
      binding.pry
      first_response = signal.responses.where(response_type: 'first').first
      repeat_response = signal.responses.where(response_type: 'repeat').first
      first_response.update_attribute(:message, first_msg)
      repeat_response.update_attribute(:message, repeat_msg)
    end

    def create_template_response(signal, first_response, repeat_response, exp_date)
      response_group = ResponseGroup.create(listen_signal_id: signal.id)
      create_response(first_response, 1, Response::Type::FIRST, response_group, exp_date)
      create_response(repeat_response, 2, Response::Type::REPEAT, response_group, exp_date)
    end

    def create_response(message, priority, type, response_group, exp_date)
      Response.create do |r|
        r.message = message
        r.priority = priority
        r.response_type = type
        r.response_group_id = response_group.id
        r.expiration_date = exp_date
      end
    end

    def create_signal(brand, identity, name, signal_type, exp_date)
      ListenSignal.create do |s|
        s.brand_id = brand.id
        s.identity_id = identity.id
        s.name = name
        s.signal_type = signal_type
        s.expiration_date = exp_date
        s.active = true
      end
    end

    def signal_params
      params.require(:listen_signal).permit(:signalType, :name, :firstResponse, :repeatResponse, :active, :expirationDate)
    end
end
