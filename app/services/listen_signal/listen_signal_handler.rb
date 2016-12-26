class ListenSignalHandler
  attr_reader :signal_params, :listen_signal, :response_group, :default_msg,
              :repeat_msg, :timed_responses


  def initialize(listen_signal, signal_params, response_params)
    @signal_params          = signal_params
    @listen_signal          = listen_signal || create_listen_signal
    @response_group         = @listen_signal.response_group || create_response_group
    @default_message        = response_params[:default_response]
    @repeat_message         = response_params[:repeat_response]
    @timed_response_params  = response_params[:responses]
  end

  def create
    ApplicationRecord.transaction do
      create_default_response
      create_repeat_response
      create_timed_responses
    end
    @listen_signal
  end

  def update
    ApplicationRecord.transaction do
      update_listen_signal
      update_default_response
      update_repeat_response
      handle_timed_responses
    end
  end

  private

  def create_listen_signal
    ListenSignal.create!(@signal_params)
  end

  def update_listen_signal
    @listen_signal.update_attributes!(@signal_params)
  end

  def create_response_group
    ResponseGroup.create!(listen_signal: @listen_signal)
  end

  def create_default_response
    Response.create_response(@default_message, Response::Type::DEFAULT, @response_group)
  end

  def create_repeat_response
    Response.create_response(@repeat_message, Response::Type::REPEAT, @response_group)
  end

  def create_timed_responses
    @timed_response_params.map do|response|
      create_timed_response(response[:message], response[:expiration_date])
    end
  end

  def create_timed_response(message, exp_date)
    Response.create_timed_response(message, exp_date, @response_group)
  end

  def update_default_response
    @listen_signal.default_response.update!(message: @default_message)
  end

  def update_repeat_response
    @listen_signal.repeat_response.update!(message: @repeat_message)
  end

  def handle_timed_responses
    handle_responses_for_delete
    handle_responses_for_update
  end

  def handle_responses_for_delete
    all_timed_responses_ids = @response_group.timed_responses.pluck(:id)
    updatable_response_ids = @timed_response_params.collect{ |r| r[:id] }
    deletable_response_ids = all_timed_responses_ids - updatable_response_ids

    deletable_response_ids.map do |id|
      response = Response.find(id)
      response.destroy
    end
  end

  def handle_responses_for_update
    @timed_response_params.map do |response|
      if response.key?(:id)
        update_timed_response(response[:id], response[:message], response[:expiration_date])
      else
        create_timed_response(response[:message], response[:expiration_date])
      end
    end
  end

  def update_timed_response(id, message, expiration_date)
    response = @listen_signal.timed_responses.where(id: id).first
    response.update_attributes!({
      message: message,
      expiration_date: expiration_date
    })
  end
end
