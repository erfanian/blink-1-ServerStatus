blink-1-ServerStatus
====================

A simple script to monitor your servers using [blink(1)](http://www.kickstarter.com/projects/thingm/blink1-the-usb-rgb-led).

**serverStatus.sh** monitors if your servers are up.

**web_popularity.sh** interfaces with the Google Analytics API to see how many visitors your website has today.

**blinkFunctions.sh** Contain a variety of functions for your blink(1). Integrates with [Pushover](www.pushover.net), and can watch openvpn server logs.

## Background

I'm running my blink(1) on a virtual machine guest because the host is unable or unwilling to run/compile the blink(1) binaries. The blink(1) USB device is passed through to the guest, and the script uses a small Linux program to reset the dongle to deal with strange device access issues. Your mileage may vary on some of the features.

The serverStatus script uses fping and curl to test a variety of server/port combinations. The web_popularity script uses Python to interface with the Google Analytics API.

The two scripts can be used more or less independantly. Both depend on blinkFunctions to control the dongle. To use web_popularity on its own, remove the call and conditional statement around serverStatus.

httplib2 is called locally because I was having troubles with SSL certs in the package.

## Prepare the Machine

Install the necessary applications:

```sudo apt-get install make git libusb-1.0-0-dev pkg-config fping python-pip```

Install the Google Analytics API Python interface:

```sudo easy_install --upgrade google-api-python-client```

Clone the blink(1) code repo:

```git clone git://github.com/todbot/blink1.git```

Compile the blink(1) binaries:

```cd blink1/commandline/ && make```

Copy the binary to your script location:

```cp ./blink1-tool ~/```

Modify your udev rules so non-root users can access the device. You may need to replug the device after this step:

```cd blink1/linux/ && sudo cp ./51-blink1.rules /etc/udev/rules.d/ && sudo udevadm control --reload-rules```

Compile the reset program and copy it to the directory where the script will be executed:

```gcc -o reset reset.c && cp ./reset ~/```

## Create the necessary API Auth Files ##

You will need a client_secrets.json file to interface with the webservice. Follow the steps and download the necessary file using Google's [quick start tutorial](https://developers.google.com/api-client-library/python/start/installation). Place this file in the same directory you run the script.

If you are running these scripts on a headless server or need a graphical interface to get your auth token, you should run the script first on a machine that you prefer and scp the client_secrets.json and analytics.dat files to the headless machine.

## Prepare the Scripts ##

Modify the serverStatus.sh script and place your servers in the HOSTS or HOSTS2 variable. They can be hostnames or IP addresses. ```man fping``` for more information. Make sure the script is executed in the same directory as the compiled reset binary.

To adjust the popularity thresholds in the script, adjust the if conditionals in web_popularity.sh

## Schedule the Script ##

Schedule the script to run without you:

```crontab -e```

For just the serverStatus add this to the crontab to check your servers every ten minutes (be sure to use bash as the executor):

```*/10 * * * * bash /home/user/serverStatus.sh```

For the web_popularity + serverStatus add:

```*/10 * * * * bash /home/user/web_popularity.sh```
