class ListenSignalsController < ApplicationController

  def create_template_signal
    @brand = current_user.brand
    @identity = @brand.identities.first

    params = signal_params
    @name = params['name']
    @signal_type = params['signalType']
    @first_response = params['firstResponse']
    @repeat_response = params['repeatResponse']
    @exp_date = params['expDate']

    @signal = create_signal(@brand, @identity, @name, @signal_type, @exp_date)
    create_template_response

    if @signal
      flash[:success] = "Alert:  #{@signal.name} signal created!"
      render json: { signal: @signal.to_json, responses: @signal.responses.to_json }
    else
      flash[:error] = 'Alert:  Please fill out missing fields'
    end
  end

  private

    def create_template_response
      response_group = ResponseGroup.create(listen_signal_id: @signal.id)
      create_response(@first_response, 1, Response::Type::FIRST, response_group, @exp_date)
      create_response(@repeat_response, 2, Response::Type::REPEAT, response_group, @exp_date)
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
      params.require(:listen_signal).permit(:signalType, :name, :firstResponse, :repeatResponse, :active, :expDate)
    end
end
