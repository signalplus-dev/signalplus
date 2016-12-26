class FriendlyHash < Hash
  include Hashie::Extensions::MethodAccess
  include Hashie::Extensions::IndifferentAccess
  include Hashie::Extensions::Coercion
  coerce_value Hash, FriendlyHash
  coerce_value Array, ->(array) do
    array.map do |el|
      el.is_a?(Hash) ? FriendlyHash.new(el) : el
    end
  end

  def initialize(hash = {})
    super
    hash.each_pair do |k,v|
      self[k] = v
    end
  end
end
