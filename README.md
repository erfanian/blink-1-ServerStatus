blink-1-ServerStatus
====================

A simple script to monitor your servers using [blink(1)](http://www.kickstarter.com/projects/thingm/blink1-the-usb-rgb-led).

## Background

I'm running my blink(1) on a virtual machine guest because the host is unable or unwilling to run/compile the blink(1) binaries. The blink(1) USB device is passed through to the guest, and the script 
uses a small linux program to reset the dongle to deal with strange device access issues.

## Prepare the Machine

Install the necessary applications:

'''sudo apt-get install make git libusb-1.0-0-dev pkg-config fping'''

Clone the blink(1) code repo:

'''git clone git://github.com/todbot/blink1.github'''

Compile the blink(1) binaries:

'''cd blink1/commandline/ && make'''

Copy the binary to your script location:

'''cp ./blink1-tool ~ (or wherever your script is)'''

Modify your udev rules so non-root users can access the device. You may need to replug the device after this step:

'''d blink1/linux/ && sudo cp ./51-blink1.rules /etc/udev/rules.d/ && sudo udevadm control --reload-rules'''

