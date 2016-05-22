require_relative 'replies/reply'

Dir[File.dirname(__FILE__) + '/replies/*.rb'].each do |f|
  next if f =~ /.+\/reply.rb/
  require f
end
