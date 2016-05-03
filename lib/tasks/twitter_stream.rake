require 'twitter'

module Twitter
  module Streaming
    class Connection
      def stream(request, response)
        client_context = OpenSSL::SSL::SSLContext.new
        port           = request.uri.port || Addressable::URI::PORT_MAPPING[request.uri.scheme]
        client         = @tcp_socket_class.new(Resolv.getaddress(request.uri.host), port)
        ssl_client     = @ssl_socket_class.new(client, client_context)

        ssl_client.connect
        request.stream(ssl_client)
        while body = ssl_client.readpartial(1024) # rubocop:disable AssignmentInCondition
          response << body
        end
      end
    end
  end
end

desc "Listens to a user's stream of mentions and direct messages"
task twitter_stream: :environment do
  begin
    Streamers::Twitter.new(Brand.find(ENV['BRAND_ID'])).stream!
  rescue StandardError => e
    # Also turn on rest polling implementation
    Rollbar.error(e)
  end
end
