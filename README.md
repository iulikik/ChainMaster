# ChainMaster Motor Controller iOS app, Raspberry Pi Server

This is a guide on how to install server for motor_control.

## SSH
After burning the Raspberry Pi OS img to SD card, enable SSH by creating an empty file in the root of SD card, named ssh (without any extention). If you are on Mac, the follow command will do the trick:

```bash
touch /Volumes/boot/ssh
```

Again, because your Raspberry Pi is headless, we need a way to automatically have it connect to Wifi when it starts up so we can login via SSH. In order to do this, we need to create a file at the root of the SD card called wpa_supplicant.conf. Replace WIFI_NAME and WIFI_PASSWORD with the actual name and password for your WiFi network.

```python
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1
country=<Insert 2 letter ISO 3166-1 country code here>
network={
 ssid="WIFI_NAME"
 psk="WIFI_PASSWORD"
}
```

In order to connect to the Raspberry Pi via SSH, we need to determine its IP address. To do this open Terminal on Mac/Linux (or Command Prompt on Windows) and  execute the following command.

```bash
ping raspberrypi.local
```
On a Mac, open terminal and use the SSH command and IP address to login.

```bash
ssh pi@192.168.0.136
```

 in case your SSH key not working and you get something like this

```bash
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@    WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!     @
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
```

 use this command

```bash
ssh-keygen -R "you server hostname or ip"
```
## UART

For next method of connection using a FT232RL usb to TTL communicator we have to enable uart by adding this line in /boot/config.txt on SD card

```python
enable_uart=1
```
I was able to access the raspberry through serial port using an FT232RL usb to TTL communicator using this command:

```bash
sudo screen /dev/cu.usbserial-00000000 115200
```

## Server on Raspberry Pi

We can start by enabling root access on our Raspberry Pi but this is not obligatory.
```bash
sudo passwd root
```

So, now lets update and upgrade our Raspberry Pi and install additional libraries
```bash
sudo apt update
sudo apt full-upgrade
sudo apt-get rpi.gpio
sudo apt-get install python-twisted
```

This is how to make a hotspot from our raspberry pi (but don't forget to include our command in /etc/rc.local)

```bash
git clone https://github.com/quangthanh010290/RPI3_HOTSPOTS.git
sudo ./install.sh
```
* Station mode: sudo sta [SSID] [password] - Connect to a network with specific ssid name and password, example:
```bash
sudo sta mySSID  myPass
```
* AP mode: sudo ap [SSID] [pass] - Create an wifi hotspot with specific ssid and pass, example:
```bash
sudo ap my_ssid 12345678
```

Do not forget to make our Raspberry Pi have a static ip address.

—————————— this part is missing for now ——————————

Lets create our script:

```bash
sudo nano /home/pi/iphoneserver.py
```

You'll find the script here:

[iphoneserver.py](iphoneserver.py)


Now we can test our server with this command:
```bash
sudo nice -n 10 python /home/pi/iphoneserver.py
```

ctrl+c to stop server.

After all tests, we should add following to rc.local to make bootable our server after restart

```bash
sudo nano /etc/rc.local
```
```python
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
```

And finaly
```bash
sudo reboot
```
