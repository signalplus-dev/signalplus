class StripeWebhook::BaseHandler
  attr_reader :event

  def initialize(event)
    @event = event
  end

  private

  def data
    event.data
  end

  def data_object
    data.object
  end
end
