from twisted.internet.protocol import Protocol, Factory
from twisted.internet import reactor

import RPi.GPIO as GPIO

GPIO.setmode(GPIO.BCM)

pinList = [2, 3, 4, 17, 27, 22, 10, 9, 11, 5, 6, 13, 19, 26, 16, 20]

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
        
        # ------------------------- 1 ------------
        
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
        
        # ------------------------- 2 ------------
        
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
        
        # ------------------------- 3 ------------
        
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
        
        # ------------------------- 4 ------------
        
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
        
        # ------------------------- 5 ------------
        
        #motor5 UP
        if (data == 'Motor5UP'):
            GPIO.output(11, GPIO.LOW)
            GPIO.output(5, GPIO.HIGH)
        
        #motor5 STOP
        if (data == 'Motor5STOP'):
            GPIO.output(11, GPIO.HIGH)
            GPIO.output(5, GPIO.HIGH)
        
        #motor5 DOWN
        if (data == 'Motor5DOWN'):
            GPIO.output(11, GPIO.HIGH)
            GPIO.output(5, GPIO.LOW)
        
        # ------------------------- 6 ------------
        
        #motor6 UP
        if (data == 'Motor6UP'):
            GPIO.output(6, GPIO.LOW)
            GPIO.output(13, GPIO.HIGH)
        
        #motor6 STOP
        if (data == 'Motor6STOP'):
            GPIO.output(6, GPIO.HIGH)
            GPIO.output(13, GPIO.HIGH)
        
        #motor6 DOWN
        if (data == 'Motor6DOWN'):
            GPIO.output(6, GPIO.HIGH)
            GPIO.output(13, GPIO.LOW)
        
        
        # ------------------------- 7 ------------
        
        #motor7 UP
        if (data == 'Motor7UP'):
            GPIO.output(19, GPIO.LOW)
            GPIO.output(26, GPIO.HIGH)
        
        #motor7 STOP
        if (data == 'Motor7STOP'):
            GPIO.output(19, GPIO.HIGH)
            GPIO.output(26, GPIO.HIGH)
        
        #motor7 DOWN
        if (data == 'Motor7DOWN'):
            GPIO.output(19, GPIO.HIGH)
            GPIO.output(26, GPIO.LOW)
        
        # ------------------------- 8 ------------
        
        #motor8 UP
        if (data == 'Motor8UP'):
            GPIO.output(16, GPIO.LOW)
            GPIO.output(20, GPIO.HIGH)
        
        #motor8 STOP
        if (data == 'Motor8STOP'):
            GPIO.output(16, GPIO.HIGH)
            GPIO.output(20, GPIO.HIGH)
        
        #motor8 DOWN
        if (data == 'Motor8DOWN'):
            GPIO.output(16, GPIO.HIGH)
            GPIO.output(20, GPIO.LOW)
        
        
                print data

factory = Factory()
factory.protocol = RaspberryLight
factory.clients = []

reactor.listenTCP(7777, factory)
print "RaspberryLight server started"
reactor.run()
