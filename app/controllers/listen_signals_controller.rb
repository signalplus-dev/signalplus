class ListenSignalsController < ApplicationController

  def create_signal
    @signal_type = params[:signal_type]
    @name = params[:signal_name]
    @status = params[:signal_status]
    @exp_date = params[:exp_date]
    @user = current_user

    @signal = SignalHandler.create_signal(@signal_type, @name, @exp_date, @status, @user)
  end
end
