require 'websocket-client-simple'
require 'rubygems'
require 'json'

class BogusSensor

def initialize(configuration,logger)
	logger.debug("Init bogus")
	ws = WebSocket::Client::Simple.connect configuration[:uri]
	logger.info("Connected")
	ws.on :message do |msg|
		begin
      data={
        :id => configuration[:id],
        :n  => msg.data.split[0].to_i
        }
      configuration[:check_out].push(JSON.generate(data))
			#logger.info("Bogus data: " + data.to_s)
		rescue Exception => e
			logger.error "Bogus sensor: Send problem: closing websocket (#{e.inspect})"
			ws.close()
		end
	end
	ws.on :open do
		logger.debug("Bogus sensor: websocket opened")
	end
	ws.on :close do |e|
		logger.info "Bogus sensor: websocket close (#{e.inspect})"
		exit 1
	end
	ws.on :error do |e|
		@logger.error "Bogus_sensor: error (#{e.inspect})"
	end
end

def run()

end

end
