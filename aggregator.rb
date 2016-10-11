require 'logger'
require './thingspeak'
require './ewma'
require './ntc_new'

# channels definition
thingspeak_queue = Queue.new
ewma_queue=Queue.new

# thingspeak mixin attributes
thingspeak_conf = {
	field: 'field1',
	inqueue: thingspeak_queue
	}

# ewma mixin attributes
ewma_conf = {
	inqueue: ewma_queue,
	outqueue: thingspeak_queue,
	gain: 16
	}
	
# ntc mixin attributes
ntc_conf = {
	outqueue: ewma_queue,
	uri: 'ws://192.168.113.177'
	}

def levelToDegrees(level)
	r = 22000
	a = -19.39
	b = 201.38+6.3
	return a*Math::log(r/((1024.0/level)-1))+b
end

logger = Logger.new(STDOUT)
logger.level = Logger::DEBUG

ts=Thread.new { 
	begin
		Thingspeak.new(thingspeak_conf, logger).run 
	rescue Exception => e
		logger.fatal "Thingspeak thread failed to spawn: #{e.inspect}"
		exit
	end 
}
logger.debug("thingspeak gone")

ewma=Thread.new { 
	begin
		EWMA.new(ewma_conf,logger).run 
	rescue Exception => e
		logger.fatal "EWMA thread failed to spawn: #{e.inspect}"
		exit
	end 
}
logger.debug("ewma gone")

ntc=Thread.new { 
	begin
		NTC.new(ntc_conf,logger).run 
	rescue Exception => e
		logger.fatal "NTC thread failed to spawn: #{e.inspect}"
		exit
	end 
}
logger.debug("ntc gone")

#begin
	#ws = WebSocket::Client::Simple.connect 'ws://192.168.113.177'
#rescue Exception => e
    #logger.fatal "Websocket can't open: #{e.inspect}"
    #exit
#end

#startTime=Time.now.to_f
#lastSend=0

#ws.on :message do |msg|
  #raw_temp=msg.data.split[1].to_i
  #logger.debug "#{(Time.now.to_f-startTime).round(3)}: "+ raw_temp.to_s
  #ewma_queue.push(raw_temp);
  #begin
    #ws.send "Ack!"
  #rescue Exception => e
    #logger.error "Send problem: closing (#{e.inspect})"
    #ws.close()
  #end
#end

#ws.on :open do
  #logger.debug "Websocket open (#{ws.url})"
#end

#ws.on :close do |e|
  #puts "-- websocket close (#{e.inspect})"
  #exit 1
#end

#ws.on :error do |e|
  #puts "-- error (#{e.inspect})"
#end

#task = Concurrent::TimerTask.new(
  #dup_on_deref: true,
  #execution_interval: 30, 
  #timeout_interval: 5) do
	#if $last < $msgcount then
		#begin
			#thingspeak_queue.push($ewma.round(2));
			#$last=$msgcount
			#"ok"
		#rescue Exception => e
			#puts "Send to ThingSpeak problem: closing (#{e.inspect})"
			#ws.close()
			#"fail ThingSpeak"
		#end
	#else
		#begin
			#puts "No data from Sensor"
			#ws.close()
			#"fail SENSOR"
		#rescue Exception => e
			#puts "WebSocket problem: closing (#{e.inspect})"
			#ws.close()
			#"fail WebSocket"
		#end
	#end
#end

#task.execute
#sleep 15
#while true do
	#sleep 30
	#if task.value.start_with? "fail" then
		#puts "Error"
		#exit
	#end
	#puts task.value
	#end
loop do
	sleep 30
	end
