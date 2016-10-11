require 'websocket-client-simple'
require 'rubygems'

class NTC

def initialize(configuration,logger)
	logger.debug("Init")
	startTime=Time.now.to_f	
	ws = WebSocket::Client::Simple.connect configuration[:uri]
	logger.info("Connected")
	ws.on :message do |msg|
		begin
			raw_temp=msg.data.split[1].to_i
			logger.info((Time.now.to_f-startTime).round(3).to_s + ": " + raw_temp.to_s)
			configuration[:level_out].push(raw_temp);
			ws.send("Ack!")
		rescue Exception => e
			logger.error "NTC: Send problem: closing websocket (#{e.inspect})"
			ws.close()
		end
	end
	ws.on :open do
		logger.debug("NTC: websocket opened")
	end
	ws.on :close do |e|
		logger.info "NTC: websocket close (#{e.inspect})"
		exit 1
	end
	ws.on :error do |e|
		@logger.error "NTC: error (#{e.inspect})"
	end
end

def run()

end

end
