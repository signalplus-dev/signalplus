class ListenSignalsController < ApplicationController

  def create_signal
    binding.pry

    @brand = current_user.brand
    @identity = @brand.identities.first.id
    @name = 'default name for now..'
    @signal_type = params['signalType']
    @exp_date = Time.now + 30.days

    @signal = create_signal(@brand, @identity, @name, @signal_type, @exp_date)
    create_template_response
  end

  private

    def create_template_response
      response_group = ResponseGroup.create(listen_signal_id: @signal.id)
      create_response(params['firstResponse'], 1, response_group, exp_date)
      create_response(params['repeatResponse'], 2 response_group, exp_date)
    end

    def create_response(message, priority, response_group, exp_date)
      Response.create do |r|
        r.message = message
        r.priority = priority
        r.response_group_id = response_group.id
        r.expiration_date = exp_date
      end
    end

    def create_signal(brand, identity, name, signal_type, exp_date, status=false)
      ListenSignal.create! do |s|
        s.brand_id = brand.id
        s.identity = identity.id
        s.name = name
        s.signal_type = signal_type
        s.expiration_date = exp_date
        s.active = status
      end
    end
end
