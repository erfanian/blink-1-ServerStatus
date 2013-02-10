#!/bin/bash
#A helper script to determine web popularity.

#Source generic blink(1) functions
. ./blinkFunctions.sh

#Call the serverStatus.sh script. We only want to know how popular we are if our servers are up!
serverCheck=$(bash ./serverStatus.sh | tail -n 1)

if [ "$serverCheck" = "hosts up" ]; then

#Call the function
get_popularity

#Associate the current users visiting with the site with the glow intensity
RGB=$visits_today

#Set up the conditional statement to gauge your popularity and call the appropriate function
  if [ $visits_today -le 255 ]; then
    setPopularity $RGB
  elif [ $visits_today -ge 266 ]; then
    highPopularity
  else
    echo "I'm not sure what's going on."
  fi
  
fi