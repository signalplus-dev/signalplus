class DashboardController < ApplicationController
  respond_to :json

  def index
    @brand = current_user.brand
    @signals = @brand.listen_signals
    @signal_types = ListenSignal::Types.values
    @type_hash = @signal_types.map do |t|
      { t.to_sym => get_signal_type_text(t) }
    end
  end

  private

  def get_signal_type_text(signal_type)
    case signal_type
      when ListenSignal::Types::OFFER
        'Send a special offer every time a follower sends a custom hashtag'
      when ListenSignal::Types::TODAY
        'Send a summary of your location or event each day a follower uses a custom hashtag'
      when ListenSignal::Types::CONTEST
        'Run a contest for your followers for a specific date range'
      when ListenSignal::Types::REMINDER
        'Send a reminder on a specific date to users when they use a custom hashtag'
    end
  end
end
