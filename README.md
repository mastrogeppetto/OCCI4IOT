# OCCI4IOT
Proof of concept for an orchestrator of a large IOT infrastructure

This software validates a design approach described in a currently submitted paper. It is a proof-of-concept. Therefore a relevant effort would be required in order to bring it to production: only the fundamental ideas are in place, it is a starting point

Basically, it helps the deployment of an IoT infrastructure, starting from a JSON file that describes its components. The JSON file follows the OCCI standard, and describes the IoT infrastructure as resources with links connecting them. In the proof-of-concept implementation the "manager" thread contains that description, already converted into a Ruby hash. Running the "manager.rb" on a host creates a three-stages pipeline, that receives data from an external sensor through a websocket, processes and filters the data and sends them to a ThingSpeak server: the writekey for the ThingSpeak account in the code is clearly bogus.

The external sensor is an Arduino that samples at regular intervals the value of a NTC resistor. For this you need an Arduino with an Ethernet shield, a 22K resistor and a 10K NTC. The sketch and the schema are found in another repo: https://github.com/mastrogeppetto/arduino_NTCwebsocket.

## HOWTO:
 
* Create an account on ThingSpeak and annotate your writekey,
* Rename secret_bogus.rb file as secret.rb and replace the bogus writekey with your one,
* Upload the code to the Arduino and connect it to the same Ethernet of the host running the "manager.rb",
* run "ruby manager.pl", 
* ...see the temperature displayed on your ThingSpeak dashboard.

If you want to understand something more:
* for the lazy, wait for the paper to be published
* for the social inclined, send me a mail
* for the impatient, read the code (it's just ruby code)

Enjoy...

## Docker HOWTO

The above procedure is for installing the code on a dedicated device (I used a Raspberry Pi). You can also create a Docker that runs the "manager": in that case go into the docker_kit directory, and use the dockerfile to build the docker and run the demo. There are also dedicated instructions.

==IMPORTANT==: you need to copy the OCCI4IOT directory into the  docker_kit directory. I know it's inelegant, but you will understand.