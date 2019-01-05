# ChainMaster

# a guide to install server for motor_control server
# in case your SSH key not working and you get something like this

#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#@    WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!     @
#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

# use this command

>ssh-keygen -R "you server hostname or ip"


# so, now lets update and upgrade our raspberry pi and install additional libraries

>sudo apt-get update
>sudo apt-get dist-upgrade
>sudo apt-get rpi.gpio
>sudo apt-get install python-twisted

# this is how to make a hotspot from our raspberry pi (but don't forget to include our command in /etc/rc.local)

git clone https://github.com/quangthanh010290/RPI3_HOTSPOTS.git
sudo ./install.sh

	•	Station mode: sudo sta [SSID] [password] - Connect to a network with specific ssid name and password ,example:
sudo sta mySSID  myPass
	•	AP mode: sudo ap [SSID] [pass] - Create an wifi hotspot with specific ssid and pass ,example:
sudo ap my_ssid 12345678

# do not forget to make our raspberry pi have a static ip address 

—————————— this part is missing for now ——————————

# lets create our script

>sudo nano /home/pi/iphoneserver.py

# here’s the script:

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


# for a test we can start our server

sudo nice -n 10 python /home/pi/iphoneserver.py

# ctrl+c to stop server
# after all tests we can >sudo nano /etc/rc.local to make bootable our server after restart

#!/bin/sh -e
#
# rc.local
#
# This script is executed at the end of each multiuser runlevel.
# Make sure that the script will "exit 0" on success or any other
# value on error.
#
# In order to enable or disable this script just change the execution
# bits.
#
# By default this script does nothing.

# Print the IP address
_IP=$(hostname -I) || true
if [ "$_IP" ]; then
  printf "My IP address is %s\n" "$_IP"
fi
sudo ap MotorControl chainmaster
sudo nice -n 10 python /home/pi/iphoneserver.py &
exit 0


# and finaly

>sudo reboot



##########   IOS APPLICATION CODE   ##########


