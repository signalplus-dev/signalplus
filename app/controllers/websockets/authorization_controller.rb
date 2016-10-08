class Websockets::AuthorizationController < WebsocketRails::BaseController
  def authorize_channels
    if can_subscribe_to_channel?
      accept_channel current_user
    else
      deny_channel({:message => 'authorization failed!'})
    end
  end

  private

  def can_subscribe_to_channel?
    channel_brand_id === current_user.brand_id
  end

  def channel
    WebsocketRails[message[:channel]]
  end

  def channel_brand_id
    channel.name[/\d+$/].to_i
  end
end
