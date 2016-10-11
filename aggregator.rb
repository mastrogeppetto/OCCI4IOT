require 'logger'

class Aggregator
	def initialize(mixins,logger)
		@logger=logger
		@mixins=mixins
	end
	def run()
		threads = [];	
		@mixins.each do |mixin,attrs|
			require "./#{mixin}"
			@logger.debug "Spawning #{mixin} thread"
			threads << Thread.new {
				begin
					Module.const_get(mixin).new(attrs,@logger).run 
				rescue Exception => e
					@logger.fatal "#{mixin} thread failed to spawn: #{e.inspect}"
					exit
				end 
			}
			@logger.debug("#{mixin} running")
		end
		threads.each { |thr| thr.join }
	end
end
