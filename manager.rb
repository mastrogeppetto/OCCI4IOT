require 'logger'
require './aggregator'
require './secret'

logger = Logger.new(STDOUT)
logger.level = Logger::DEBUG

channel={}
channel["channel1"]=Queue.new
channel["channel2"]=Queue.new

mixins = {
	'NTCtoDegrees' => {
		ntc_in: channel["channel1"],
		degrees_out: channel["channel2"],
		gain: 16,
		period: 30
	},
	'NTC' => {
		level_out: channel["channel1"],
		period:1,
		uri: 'ws://192.168.113.177'
	},
	'ThingSpeak' => {
		value_in: channel["channel2"],
		field: 'field1',
		uri: 'http://api.thingspeak.com/update.json',
		writekey: $secret[:writekey]
	}
}

temp=Thread.new { 
	begin
		Aggregator.new(mixins,logger).run()
	rescue Exception => e
		logger.fatal "Aggregator thread failed to spawn: #{e.inspect}"
		exit
	end
	}

temp.join
