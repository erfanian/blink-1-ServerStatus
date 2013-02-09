#!/bin/bash
# serverStatus.sh - Monitor the availability of your servers with blink(1)
# Based on code from http://www.cyberciti.biz/tips/linux-unix-profiling-network-connectivity-with-fping.html,
# and http://forums.x-plane.org/index.php?app=downloads&showfile=9485.

#Source generic blink(1) functions
. ./blinkFunctions.sh

#Enter a list of the hostnames or IP Addresses you want to check using fping.
HOSTS="hostname1 ipaddress2"
#Enter a list of addresses you wish to check with curl.
HOSTS2="ip1:port1 ip2:port2"
#Set a global variable to track if one server is down
RESULT=0

#Test HOSTS with fping.
for h in $HOSTS
do
  fping -u $h >& /dev/null
  if [ $? -ne 1 ]; then
          lightOff
  else
	  lightOn $h 
  fi
done

#Now let's do the same run with curl so we can use ip addresses on a certain port.
for h in $HOSTS2
do
  curl $h >& /dev/null
  if [ $? -ne 7 ]; then
          lightOff
  else
	  lightOn $h
  fi
done

