class ResponseSerializer < ActiveModel::Serializer
  attributes :id, :message, :response_type, :expiration_date, :priority
end
