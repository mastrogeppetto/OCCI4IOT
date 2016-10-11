require 'websocket-client-simple'
require 'rubygems'
require 'net/http'
require 'concurrent'

class NTC;

def initialize (configuration, logger)
	@configuration=configuration
	@logger=logger
	@startTime=Time.now.to_f
	
	@ws=WebSocket::Client::Simple.connect 'ws://192.168.113.177'
	@logger.debug "NTC: websocket connected"+@ws.to_s
	
	@ws.on :message do |msg|
		begin
			raw_temp=msg.data.split[1].to_i
			@logger.debug "#{(Time.now.to_f-startTime).round(3)}: "+ raw_temp.to_s
			@configuration[:outqueue].push(raw_temp);
			@ws.send "Ack!"
		rescue Exception => e
			@logger.error "NTC: Send problem: closing websocket (#{e.inspect})"
			@ws.close()
		end
	end
	
	@ws.on :open do
		begin
			@logger.debug "Websocket open"
		rescue Exception => e
			@logger.error "NTC: something wrong (#{e.inspect})"
			@ws.close()
		end
	end
	
	@ws.on :close do |e|
		@logger.info "NTC: websocket close (#{e.inspect})"
		exit 1
	end
	
	@ws.on :error do |e|
		@logger.error "-- error (#{e.inspect})"
	end
end

def run()
	
end
end
