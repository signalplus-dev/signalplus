json.data do
  json.signals @signals do |s|
    json.name s.name
    json.active s.active
    json.expiration_date s.expiration_date.strftime('%Y-%m-%d')
    json.signal_type s.signal_type
    json.brand_name s.brand.name
    json.responses s.responses do |r|
      json.message r.message
      json.type r.response_type
      json.expiration_date r.expiration_date.strftime('%Y-%m-%d')
      json.priority r.priority
    end
  end

  json.signal_types @type_hash do |t|
    json.type t.keys.first
    json.text t.values.first
  end
end
