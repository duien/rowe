if ENV['MONGOHQ_URL'].present?
  MongoMapper.config = {Rails.env => {'uri' => ENV['MONGOHQ_URL']}}
else
  MongoMapper.config = {Rails.env => {'uri' => "mongodb://localhost/rowe-#{Rails.env}" }}
end

MongoMapper.connect(Rails.env)

if defined?(PhusionPassenger)
   PhusionPassenger.on_event(:starting_worker_process) do |forked|
     MongoMapper.connection.connect_to_master if forked
   end
end

