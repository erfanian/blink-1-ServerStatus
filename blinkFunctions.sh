#!/bin/bash
# blinkFunctions.sh - Generic functions to control the blink

#Get the physical address of the USB blink(1) dongle
USB_ID=$(lsusb -d 27b8:01ed)

#Set the flare:
function lightOn ()
{
  echo $h down
  #turn on the alert light to bright red
echo  ./blink1-tool -m 100 --rgb 255,0,0
echo  reset
  #Break from the test loops because we know something is wrong.
  RESULT=1
}

#Else Quiet
function lightOff ()
{
  if [ $RESULT -ne 1 ]; then
   echo "hosts up"
   #turn off the alert light
echo   ./blink1-tool --off
echo   reset
  fi
}

#Reset the USB due to some issues on my virtual machine
function reset ()
{
 ./reset /dev/bus/usb/${USB_ID:4:3}/${USB_ID:15:3}
}