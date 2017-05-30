require 'logger'

class Aggregator
	def initialize(mixins,logger)
		@logger=logger
		@mixins=mixins
	end
	def run()
		threads = [];	
		@mixins.each do |id,attrs|
      mixinType=attrs[:type]
			require "./#{mixinType}"
			@logger.debug "Spawning #{mixinType} thread"
			threads << Thread.new {
				begin
					Module.const_get(mixinType).new(attrs,@logger).run 
				rescue Exception => e
					@logger.fatal "#{mixin} thread failed to spawn: #{e.inspect}"
					exit
				end 
			}
			@logger.debug("#{mixinType} running")
		end
		threads.each { |thr| thr.join }
	end
end
