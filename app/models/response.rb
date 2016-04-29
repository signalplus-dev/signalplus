class Response < ActiveRecord::Base
  belongs_to :response_group

  def self.provider
    response_group.listen_signal.provider
  end

end
