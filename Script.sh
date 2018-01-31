#!/bin/sh

#  Script.sh
#  Chain Master
#
#  Created by IULIAN MORARI on 2/1/18.
#  Copyright © 2018 Ik Moraru. All rights reserved.

# ---------- PYTHON SCRIPT ---------- #

from twisted.internet.protocol import Protocol, Factory
from twisted.internet import reactor

import RPi.GPIO as GPIO

GPIO.setmode(GPIO.BOARD) ## Use board pin numbering
GPIO.setup(7, GPIO.OUT) ## Setup GPIO Pin 7 to OUT

class RaspberryLight(Protocol):
def connectionMade(self):
#self.transport.write("""connected""")
self.factory.clients.append(self)
print "clients are ", self.factory.clients

def connectionLost(self, reason):
print "connection lost ", self.factory.clients
self.factory.clients.remove(self)


def dataReceived(self, data):
msg = ""

if (data == 'P7H'):
msg = "Pin 7 is now High"
GPIO.output(7, True)

elif (data == 'P7L'):
msg = "Pin 7 is now Low"
GPIO.output(7, False)


print msg

factory = Factory()
factory.protocol = RaspberryLight
factory.clients = []

reactor.listenTCP(7777, factory)
print "RaspberryLight server started"
reactor.run()
