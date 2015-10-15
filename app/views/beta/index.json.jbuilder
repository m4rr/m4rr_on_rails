json.array!(@beta) do |betum|
  json.extract! betum, :id, :first_name, :last_name, :email, :desc
  json.url betum_url(betum, format: :json)
end
