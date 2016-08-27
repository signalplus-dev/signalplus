class Api::V1::SessionsController < DeviseTokenAuth::SessionsController
  skip_before_action :verify_authenticity_token, only: [:destroy]
end
