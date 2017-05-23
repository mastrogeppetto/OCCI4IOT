require 'concurrent'

class NTCtoDegrees;
	def levelToDegrees(level)
		r = 22000
		a = -19.39
		b = 201.38+6.3
		return a*Math::log(r/((1024.0/level)-1))+b
	end
	def initialize (configuration, logger)
		@configuration=configuration
		@logger=logger
	end
	def run()
		task = Concurrent::TimerTask.new(
		dup_on_deref: true,
		execution_interval: 60, 
		timeout_interval: 5) {
			@configuration[:degrees_out].push(@ewma.round(2))
			logger.debug("EWMA: new filtered data sent")
			}
		task.execute
		loop do
			value=levelToDegrees(@configuration[:ntc_in].pop)
			@ewma=defined?(@ewma) ? ((@configuration[:gain]-1)*@ewma+value)/@configuration[:gain] : value;
		end
	end
end
