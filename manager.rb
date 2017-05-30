require 'logger'
require './aggregator'
require './secret'

logger = Logger.new(STDOUT)
logger.level = Logger::DEBUG

channel={}
channel["channel1"]=Queue.new
channel["channel2"]=Queue.new
channel["channel3"]=Queue.new

mixins = {
	'conv' => {
    		type: 'NTCtoDegrees',
		ntc_in: channel["channel1"],
		degrees_out: channel["channel2"],
		gain: 16,
		period: 30
	},
	'temp' => {
		type: 'NTC',
		level_out: channel["channel1"],
		period:1,
		uri: 'ws://192.168.113.177'
	},
	'Bog1' => {
    type:'BogusSensor',
    id:'a',
		check_out: channel["channel3"],
		period:1,
		uri: "ws://#{ENV['SINK']}:8000"
	},
	'Bog2' => {
    type:'BogusSensor',
    id:'b',
		check_out: channel["channel3"],
		period:1,
		uri: "ws://#{ENV['SINK']}:8000"
	},
  'Bog3' => {
    type:'BogusSensor',
    id:'c',
		check_out: channel["channel3"],
		period:1,
		uri: "ws://#{ENV['SINK']}:8000"
	},
  'Bog4' => {
    type:'BogusSensor',
    id:'d',
		check_out: channel["channel3"],
		period:1,
		uri: "ws://#{ENV['SINK']}:8000"
	},
  'Bog5' => {
    type:'BogusSensor',
    id:'e',
		check_out: channel["channel3"],
		period:1,
		uri: "ws://#{ENV['SINK']}:8000"
	},
  'Bog6' => {
    type:'BogusSensor',
    id:'f',
		check_out: channel["channel3"],
		period:1,
		uri: "ws://#{ENV['SINK']}:8000"
	},
  'Bog7' => {
    type:'BogusSensor',
    id:'g',
		check_out: channel["channel3"],
		period:1,
		uri: "ws://#{ENV['SINK']}:8000"
	},
	'Bog8' => {
    type:'BogusSensor',
    id:'h',
		check_out: channel["channel3"],
		period:1,
		uri: "ws://#{ENV['SINK']}:8000"
	},
  'Bog9' => {
    type:'BogusSensor',
    id:'i',
		check_out: channel["channel3"],
		period:1,
		uri: "ws://#{ENV['SINK']}:8000"
	},
  'Bog10' => {
    type:'BogusSensor',
    id:'j',
		check_out: channel["channel3"],
		period:1,
		uri: "ws://#{ENV['SINK']}:8000"
	},
  'Bog11' => {
    type:'BogusSensor',
    id:'k',
		check_out: channel["channel3"],
		period:1,
		uri: "ws://#{ENV['SINK']}:8000"
	},
  'Bog12' => {
    type:'BogusSensor',
    id:'l',
		check_out: channel["channel3"],
		period:1,
		uri: "ws://#{ENV['SINK']}:8000"
	},
  'Bog13' => {
    type:'BogusSensor',
    id:'m',
		check_out: channel["channel3"],
		period:1,
		uri: "ws://#{ENV['SINK']}:8000"
	},
  'Bog14' => {
    type:'BogusSensor',
    id:'n',
		check_out: channel["channel3"],
		period:1,
		uri: "ws://#{ENV['SINK']}:8000"
	},
  'Bog15' => {
    type:'BogusSensor',
    id:'o',
		check_out: channel["channel3"],
		period:1,
		uri: "ws://#{ENV['SINK']}:8000"
	},
  'Bog16' => {
    type:'BogusSensor',
    id:'p',
		check_out: channel["channel3"],
		period:1,
		uri: "ws://#{ENV['SINK']}:8000"
	},
  'Bog17' => {
    type:'BogusSensor',
    id:'q',
		check_out: channel["channel3"],
		period:1,
		uri: "ws://#{ENV['SINK']}:8000"
	},
  'Bog18' => {
    type:'BogusSensor',
    id:'r',
		check_out: channel["channel3"],
		period:1,
		uri: "ws://#{ENV['SINK']}:8000"
	},
  'Bog19' => {
    type:'BogusSensor',
    id:'s',
		check_out: channel["channel3"],
		period:1,
		uri: "ws://#{ENV['SINK']}:8000"
	},
	'ts' => {
    type:'ThingSpeak',
		value_in: channel["channel2"],
		field: 'field1',
		uri: 'http://api.thingspeak.com/update.json',
		writekey: $secret[:writekey]
	},
  'trash' => {
    type:'Sink',
		sink_in: channel["channel3"]
	}
}

temp=Thread.new { 
	begin
    mixins
		Aggregator.new(mixins,logger).run()
	rescue Exception => e
		logger.fatal "Aggregator thread failed to spawn: #{e.inspect}"
		exit
	end
	}

temp.join
