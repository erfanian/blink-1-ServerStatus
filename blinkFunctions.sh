#!/bin/bash
# blinkFunctions.sh - Generic functions to control the blink(1)

#Get the physical address of the USB blink(1) dongle
USB_ID=$(lsusb -d 27b8:01ed)

#Set pushover token:
pushover_token="supplyTokenString"
pushover_user="supplyUserString"

#If you run an openVPN server, see if anyone is connected. Substitute your own subnet:
function vpn ()
{
  if cat openvpn-status.log | grep 10.8.0
    then
      #Make the light blue.
      ./blink1-tool --blue
      reset
      #Flash the brake just in case
      RESULT=1
      #Make sure interested parties know via pushover
      pushover_verify
  fi
}

#Make sure we really want to send important pushover notifications:
function pushover_verify ()
{
#Get the receipt number
receipt=$(cat pushCheck | grep -o -w "..............................")

  if curl https://api.pushover.net/1/receipts/$receipt.json?token=pushover_token | grep "acknowledged.:1"
    then
      #we've already sent the notification. If no receipt, then message could be expired. We'll send another just in case.
      echo "Alert has already been sent."
      exit
    else
      #send an alert
      pushmsg=$(cat openvpn-status.log | grep 10.8.0...)
      pushover "${pushmsg:0:11} connected to vpn" -1
      echo "${pushmsg:0:11} connected to vpn"
      #Stop the presses, VPN status supersedes server status
      exit
  fi
}

#Cleanup files to make sure important messages get through:
function pushover_cleanup ()
{
  #if the file exists delete it
  if [ -f pushCheck ]
    then
      rm pushCheck
    else
      echo "file does not exist"
  fi
}

#Set the flare:
function lightOn ()
{
  echo $h down
  #turn on the alert light to bright red
  ./blink1-tool -m 100 --rgb 255,0,0
  reset
  pushover "$h down" 0
  #Break from the test loops because we know something is wrong.
  RESULT=1
}

#Else Quiet
function lightOff ()
{
   if [ $RESULT -ne 1 ]; then
    #turn off the alert light
    ./blink1-tool --off
    reset
    echo "hosts up"
   fi
}

#Make a function to call the python script to get data from Google Analytics
function get_popularity ()
{
  #Be sure to change the python path on your system if you run into trouble
  visits_today=$(/usr/bin/python2.7 ./google_analytics_popularity.py)
  return $visits_today
}

#Low popularity signal; the blink tool doesn't turn on the lights below this threshold.
function lowPopularity ()
{
  ./blink1-tool --rgb 16,16,16
  reset
}

#General popularity signal
function setPopularity ()
{
  ./blink1-tool --rgb $1,$1,$1
  reset
}

#High popularity signal
function highPopularity ()
{
  ./blink1-tool --rgb 255,255,255
  reset
}

#Reset the USB due to some issues on my virtual machine
function reset ()
{
 ./reset /dev/bus/usb/${USB_ID:4:3}/${USB_ID:15:3}
}

#Call your phone or smartwatch using pushover.net
function pushover()
{
curl -s \
  -F "token=$pushover_token" \
  -F "user=$pushover_user" \
  -F "title=Server Status" \
  -F "sound=none" \
  -F "priority=$2"\
  -F "message=$1" \
  -F "expire=43200" \
  -F "retry=1200" \
  https://api.pushover.net/1/messages.json > pushCheck
}