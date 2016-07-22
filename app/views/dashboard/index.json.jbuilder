json.data do 
  json.signals @signals do |s|
    json.name s.name
    json.active s.active
    json.expiration_date s.expiration_date
    json.signal_type s.signal_type
  end

  json.signal_types @type_hash do |t|
    json.type t.keys.first
    json.text t.values.first
  end
end
