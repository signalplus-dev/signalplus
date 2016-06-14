class BrandsController < ApplicationController
  def index
    @brand = current_user.brand
  end

end
