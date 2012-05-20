#!/bin/sh
# Toggle wireless device on Asus K52 laptops

WLANSTATUS=`cat /sys/class/ieee80211/phy*/rfkill*/state`

test -z $WLANSTATUS && exit 1

if [ $WLANSTATUS = 2 ]; then
    echo 0 > /sys/devices/platform/asus_laptop/wlan    
elif [ $WLANSTATUS = 1 ]; then
    echo 1 > /sys/devices/platform/asus_laptop/wlan
fi
