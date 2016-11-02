class Api::V1::InvoicesController < Api::V1::BaseController
  before_action :get_brand, only: [:index]
  before_action :ensure_user_can_perform_action, only: [:index]

  def index
    render json: @brand.invoices, each_serializer: InvoiceSerializer
  end
end
