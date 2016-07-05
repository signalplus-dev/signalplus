class DashboardController < ApplicationController
  respond_to :json

  def index
    @brand = current_user.brand
    @signal_types = ListenSignal::Types.values
  end
end
