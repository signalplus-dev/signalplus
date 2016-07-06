class DashboardController < ApplicationController
  respond_to :json

  def index
    @brand = current_user.brand
    @signal_types = ListenSignal::Types.values
  end


  def get_data
    # @signals = current_user.brand.listen_signals
    # @signal_types = ListenSignal::Types.values

    # render json: {
    #   signals: @signals,
    #   active_signals: @signals.active,
    #   all_types: @signal_types
    # }
    render json: ListenSignal.all
  end
end
