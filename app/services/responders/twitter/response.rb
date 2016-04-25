require_relative 'responses/response'

Dir[File.dirname(__FILE__) + '/responses/*.rb'].each do |f|
  next if f =~ /.+\/response.rb/
  require f
end
