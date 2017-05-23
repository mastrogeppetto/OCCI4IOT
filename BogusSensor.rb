require 'websocket-client-simple'
require 'rubygems'

class BogusSensor

def initialize(configuration,logger)
	logger.debug("Init bogus")
	ws = WebSocket::Client::Simple.connect configuration[:uri]
	logger.info("Connected")
	ws.on :message do |msg|
		begin
			data=msg.data.split[0].to_i
			logger.info("Bogus data: " + data.to_s)
#			configuration[:level_out].push(raw_temp);
#			ws.send("Ack!")
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
