class ListenSignalsController < ApplicationController

  def create
    @signal_type = params[:signal_type]
    @name = params[:signal_name]
    @exp_date = params[:exp_date]
    @user = current_user

    @signal = SignalHandler.create_signal(@signal_type, @name, @exp_date, @user)

  end
end
