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
msg = ""

if (data == 'Motor1UP'):        #motor1 UP
msg = "Motor 1 UP"
GPIO.output(2, GPIO.LOW)
GPIO.output(3, GPIO.HIGH)

if (data == 'Motor1STOP'):        #motor1 STOP
msg = "Motor 1 Stop"
GPIO.output(2, GPIO.HIGH)
GPIO.output(3, GPIO.HIGH)

if (data == 'Motor1DOWN'):        #motor1 DOWN
msg = "Motor 1 Down"
GPIO.output(2, GPIO.HIGH)
GPIO.output(3, GPIO.LOW)

if (data == 'Motor2UP'):
msg = "Motor 2 UP"
GPIO.output(4, GPIO.LOW)
GPIO.output(17, GPIO.HIGH)

if (data == 'Motor2STOP'):              #motor2 STOP
msg = "Motor 2 Stop"
GPIO.output(4, GPIO.HIGH)
GPIO.output(17, GPIO.HIGH)

if (data == 'Motor2DOWN'):
msg = "Motor 2 Down"
GPIO.output(4, GPIO.HIGH)
GPIO.output(17, GPIO.LOW)

if (data == 'Motor3UP'):
msg = "Motor 3 UP"
GPIO.output(27, GPIO.LOW)
GPIO.output(22, GPIO.HIGH)

if (data == 'Motor3STOP'):              #motor3 STOP
msg = "Motor 3 Stop"
GPIO.output(27, GPIO.HIGH)
GPIO.output(22, GPIO.HIGH)

if (data == 'Motor3DOWN'):
msg = "Motor 3 Down"
GPIO.output(27, GPIO.HIGH)
GPIO.output(22, GPIO.LOW)

if (data == 'Motor4UP'):
msg = "Motor 4 UP"
GPIO.output(10, GPIO.LOW)
GPIO.output(9, GPIO.HIGH)

if (data == 'Motor4STOP'):              #motor4 STOP
msg = "Motor 4 Stop"
GPIO.output(10, GPIO.HIGH)
GPIO.output(9, GPIO.HIGH)

if (data == 'Motor4DOWN'):
msg = "Motor 4 Down"
GPIO.output(10, GPIO.HIGH)
GPIO.output(9, GPIO.LOW)


print msg

factory = Factory()
factory.protocol = RaspberryLight
factory.clients = []

reactor.listenTCP(7777, factory)
print "RaspberryLight server started"
reactor.run()
