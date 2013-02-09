#!/bin/bash
#A helper script to determine web popularity.

#Make a function to call the python script to get data from Google Analytics
get_popularity ()
{
  visits_today=$(/usr/bin/python2.7 ./google_analytics_popularity.py)
  return $visits_today
}

#Call the function
get_popularity

#Set up the conditional statement to gauge your popularity
if [ $visits_today -le 50 ]; then
  echo "low popularity"
elif [ $visits_today -le 100 ]; then
  echo "mild popularity"
elif [ $visits_today -ge 101 ]; then
  echo "super popular"
else
  echo "I'm not sure what's going on."
fi