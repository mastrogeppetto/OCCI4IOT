# OCCI4IOT
Proof of concept for an orchestrator of a large IOT infrastructure

This software validates a design approach described in a currently submitted paper. It is a proof-of-concept:
therefore a relevant effort is required to bring it to production, but the fundamnental ideas are in place.
It may be considered as a starting point

Basically, it helps the deployment of an IoT infrastructure, starting from a JSON file that describes it. The JSON file
follows the OCCI standard, and describes the IoT infrastructure as resources with links connecting them. In the proof
of concept the "manager" thread contains that description, already converted into a Ruby hash. Running the "manager.rb"
on a host creates a three-stages pipeline, that receives data from an external sensor through a websocket, processes
and filters the data and sends them to the ThingSpeak server: the writekey in the code is clearly bogus.

The .ino code is a temperature sensor for an Arduino with an Ethernet shield. The sensor is a simple voltage divider
with an NTC 10K to the ground, and a 12 KOhm resistor to the 5Vcc pin of the Arduino. The output is connected to the A0
pin of the Arduino.

HOWTO: 
* Create an account on ThingSpeak and annotate your writekey,
* Rename secret_bogus.rb file as secret.rb and replace the bogus writeky with your one,
* Upload the code to the Arduino and connect it to the same Ethernet of the host running the "manager.rb",
* run "ruby manager.pl", 
* ...see the temperature displayed on your ThingSpeak dashboard.

If you want to understand something more:
-) for the lazy, wait for the paper to be published
-) for the social inclined, send me a mail
-) for the impatient, read the code (it's just ruby code)

Enjoy...
