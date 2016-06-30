class BrandsController < ApplicationController
  def index
    @brand = current_user.brand
    @signal_types = ListenSignal::Types.values
  end
end
