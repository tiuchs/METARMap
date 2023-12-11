#!/bin/sh

# Install packages
echo "Updating packages"
sudo apt-get update && sudo apt-get upgrade -y

echo "Installing required packages"
apt-get install python3 python3-pip git -y

sudo pip3 install rpi_ws281x adafruit-circuitpython-neopixel

echo "downloading METARMap from github"
git clone https://github.com/tiuchs/METARMap.git /home/pi/METARMap

echo "moving files to the home directory"
cd METARMap
cp displaymetar.py lightsoff.sh metar.py pixelsoff.py refresh.sh /home/pi/
cd ..

echo 'KPSN
KDKR
KJSO 
KOCH 
K4F2 
KF17 
K3F3 
KIER 
KPOE 
KDRI 
KACP 
KAEX 
KESF 
KHEZ 
KBTR 
KHZR 
KLFT 
KOPL 
K3R7 
KLCH 
K5R8' > airports

## Set the number of LED lights
CONFIG="/home/pi/metar.py"

# If a line containing "LED_COUNT		= 50" exists
if grep -Fq "LED_COUNT		= 50" $CONFIG
then
	# Replace the line
	echo "LED_COUNT		= 20"
	sed -i "s/LED_COUNT		= 50/LED_COUNT		= 20/g" $CONFIG
else
	# Create the definition
	echo "LED_COUNT		= 50. Creating definition"
	echo "" >> $CONFIG
fi

chmod +xr displaymetar.py
chmod +xr lightsoff.sh
chmod +xr metar.py
chmod +xr pixelsoff.py
chmod +xr refresh.sh

echo "setting crontab"
sudo sh -c 'cat <<EOF > /var/spool/cron/crontabs/root
*/5 7-21 * * *  /home/pi/refresh.sh
05 22 * * *     /home/pi/lightsoff.sh
EOF'
sudo /etc/init.d/cron restart

echo "Install complete, rebooting."
#reboot
sudo python3 metar.py
