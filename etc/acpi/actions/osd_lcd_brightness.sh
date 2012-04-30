#!/bin/sh

LCD=`acpi -V | grep LCD | awk '{$0=substr($0,16,2); print $0}'`
PERCENT=$(( (15-$LCD)*100/15 ))

osd_cat -o 700 -A center -f -misc-fixed-medium-r-semicondensed--*-180-*-*-c-*-*-* -d 2 -b percentage -P $PERCENT -c green -T "Brightness: $PERCENT%"&
PID=$!
PID2=`cat /tmp/osd.pid`
echo $PID > /tmp/osd.pid
kill $PID2 2>&1 1>/dev/null
