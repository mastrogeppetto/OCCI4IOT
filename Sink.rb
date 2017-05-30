require 'net/http'
require 'json'

class Sink;
  @count={}
	def initialize (configuration, logger)
		@configuration=configuration
		@logger=logger
    @count={}
    @n=0
	end	
	def run()
		@logger.debug("Sink ready to receive")
		loop do
      @n+=1
      msg=JSON.parse(@configuration[:sink_in].pop)
      if @count.has_key? msg['id'] then
        @count[msg['id']]+=1
      else
        @count[msg['id']]=0
      end
			value=msg['n']
			@logger.debug "SINK: Bins=#{@count.length} Max=#{@count.values.max} Delta=#{@count.values.max-@count.values.min}" if @n % 200 == 0 
		end
	end
end
