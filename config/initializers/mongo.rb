if ENV['MONGOHQ_URL']
  MongoMapper.config = {RAILS_ENV => {'uri' => ENV['MONGOHQ_URL']}}
else
  MongoMapper.config = {RAILS_ENV => {'uri' => 'mongodb://localhost'}}
end

MongoMapper.connect(RAILS_ENV)
MongoMapper.database = "rowe-#{Rails.env}"

if defined?(PhusionPassenger)
   PhusionPassenger.on_event(:starting_worker_process) do |forked|
     MongoMapper.connection.connect_to_master if forked
   end
end

