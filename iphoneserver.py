from twisted.internet.protocol import Protocol, Factory
from twisted.internet import reactor

import RPi.GPIO as GPIO

GPIO.setmode(GPIO.BCM)

pinList = [2, 3, 4, 17, 27, 22, 10, 9]

# loop through pins and set mode and state to 'low'

for i in pinList:
GPIO.setup(i, GPIO.OUT)
for i in pinList:
GPIO.output(i, GPIO.HIGH)

class RaspberryLight(Protocol):
def connectionMade(self):
#self.transport.write("""connected""")
self.factory.clients.append(self)
print "clients are ", self.factory.clients

def connectionLost(self, reason):
print "connection lost ", self.factory.clients
self.factory.clients.remove(self)

def dataReceived(self, data):

#motor1 UP
if (data == 'Motor1UP'):
GPIO.output(2, GPIO.LOW)
GPIO.output(3, GPIO.HIGH)

#motor1 STOP
if (data == 'Motor1STOP'):
GPIO.output(2, GPIO.HIGH)
GPIO.output(3, GPIO.HIGH)

#motor1 DOWN
if (data == 'Motor1DOWN'):
GPIO.output(2, GPIO.HIGH)
GPIO.output(3, GPIO.LOW)

#motor2 UP
if (data == 'Motor2UP'):
GPIO.output(4, GPIO.LOW)
GPIO.output(17, GPIO.HIGH)

#motor2 STOP
if (data == 'Motor2STOP'):
GPIO.output(4, GPIO.HIGH)
GPIO.output(17, GPIO.HIGH)

#motor2 DOWN
if (data == 'Motor2DOWN'):
GPIO.output(4, GPIO.HIGH)
GPIO.output(17, GPIO.LOW)

#motor3 UP
if (data == 'Motor3UP'):
GPIO.output(27, GPIO.LOW)
GPIO.output(22, GPIO.HIGH)

#motor3 STOP
if (data == 'Motor3STOP'):
GPIO.output(27, GPIO.HIGH)
GPIO.output(22, GPIO.HIGH)

#motor3 DOWN
if (data == 'Motor3DOWN'):
GPIO.output(27, GPIO.HIGH)
GPIO.output(22, GPIO.LOW)

#motor4 UP
if (data == 'Motor4UP'):
GPIO.output(10, GPIO.LOW)
GPIO.output(9, GPIO.HIGH)

#motor4 STOP
if (data == 'Motor4STOP'):
GPIO.output(10, GPIO.HIGH)
GPIO.output(9, GPIO.HIGH)

#motor4 DOWN
if (data == 'Motor4DOWN'):
GPIO.output(10, GPIO.HIGH)
GPIO.output(9, GPIO.LOW)

print data

factory = Factory()
factory.protocol = RaspberryLight
factory.clients = []

reactor.listenTCP(7777, factory)
print "RaspberryLight server started"
reactor.run()
