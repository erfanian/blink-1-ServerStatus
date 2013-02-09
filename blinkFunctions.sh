#!/bin/bash
# blinkFunctions.sh - Generic functions to control the blink

#Get the physical address of the USB blink(1) dongle
USB_ID=$(lsusb -d 27b8:01ed)

#Set the flare:
function lightOn ()
{
  echo $h down
  #turn on the alert light to bright red
  ./blink1-tool -m 100 --rgb 255,0,0
  reset
  #Break from the test loops because we know something is wrong.
  RESULT=1
}

#Else Quiet
function lightOff ()
{
   if [ $RESULT -ne 1 ]; then
    #turn off the alert light
    echo   ./blink1-tool --off
    echo   reset
    echo "hosts up"
   fi
}

#Make a function to call the python script to get data from Google Analytics
function get_popularity ()
{
  #Be sure to change the python path on your system  if you run into trouble
  visits_today=$(/usr/bin/python2.7 ./google_analytics_popularity.py)
  return $visits_today
}

#Low popularity signal
function lowPopularity ()
{
  ./blink1-tool --rgb 85,85,85
  reset
}

#Medium popularity signal
function mediumPopularity ()
{
  ./blink1-tool --rgb 170,170,170
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