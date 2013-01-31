#!/bin/bash
# serverStatus.sh - Monitor the availability of your servers with blink(1)
# Based on code from http://www.cyberciti.biz/tips/linux-unix-profiling-network-connectivity-with-fping.html,
# and http://forums.x-plane.org/index.php?app=downloads&showfile=9485.

#Enter a list of the hostnames or IP Addresses you want to check.
HOSTS="hostname1 ipaddress1"
DLIST=""
#Get the physical address of the USB blink(1) dongle
USB_ID=$(lsusb -d 27b8:01ed)

for h in $HOSTS
do
  fping -u $h >& /dev/null
  if [ $? -ne 1 ]; then
          echo "hosts up"
          #turn off the alert light
          ./blink1-tool --off
          #reset the USB due to some issues on my virtual machine
          ./reset /dev/bus/usb/${USB_ID:4:3}/${UB_ID:15:3}
  else
	  echo ${h} down
	  #turn on the alert light to bright red
          ./blink1-tool -m 100 --rgb 255,0,0
          #reset the USB due to some issues on my virtual machine
          ./reset /dev/bus/usb/${USB_ID:4:3}/${UB_ID:15:3}	  
  fi
done