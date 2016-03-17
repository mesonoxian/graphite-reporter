require 'sinatra'
require 'yaml'
require 'json'
require 'graphite-api'
require 'logger'

GraphiteAPI::Logger.logger = ::Logger.new(STDERR)
GraphiteAPI::Logger.logger.level = ::Logger::DEBUG

config = YAML.load_file('./config/config.yml')
client = GraphiteAPI.new(graphite: '%s:%s' % [config['graphite_ip'], config['graphite_port']])


configure do
  set :bind, config['server_ip']
  set :port, config['server_port']
end


post '/report' do
  request_body = JSON.parse(request.body.read.to_s)
  begin
    response = client.metrics request_body['metric'] => request_body['value']
    status 200
    body response
  rescue Exception => e
    status 400
    body e.message
  end
end
