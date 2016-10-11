class Thingspeak;

require 'net/http'

def initialize (configuration, logger)
	@configuration=configuration
	@logger=logger
end

def run()
	@logger.debug("Thingspeak listening for data")
	loop do
		value=@configuration[:inqueue].pop
		uri = URI('http://api.thingspeak.com/update.json')
		writekey = "71PZRVYSK1J4FFQ0"
		begin
			req = Net::HTTP::Post.new(uri)
			req["X-THINGSPEAKAPIKEY"]=writekey
			req.set_form_data(@configuration[:field] => value)
			res = Net::HTTP.start(uri.hostname, uri.port) do |http|
				http.request(req)
			end
		rescue Exception => e
			@logger.error "Problems posting new value(2): #{e.message}"
			puts e.backtrace.inspect
		end
		@logger.debug "THINGSPEAK: \tdata sent #{value}" 
	end
end

end
