#!/bin/sh

export DISPLAY=":0.0"
export XAUTHORITY="/home/lahwaacz/.Xauthority"

VOLUME=`amixer get Master | grep 'Mono: Playback' | awk '{$0=substr($0,22,5); a=index($0,"%"); if (a>3) $0=substr($0,2,4); $0=int($0); print $0}'`

amixer get Master,0 |grep 'Mono: Playback' |grep -F [on] >/dev/null
if [ "$?" -ne 0 ]; then
    COLOUR="red"
    VOLUME="0"
else
    COLOUR="green"
fi

osd_cat -o 700 -A center -f -misc-fixed-medium-r-semicondensed--*-180-*-*-c-*-*-* -d 2 -b percentage -P $VOLUME -c $COLOUR -T "Volume: $VOLUME%"&
VOLUME_PID=$!
VOLUME_PID2=`cat /tmp/osd.pid`
echo $VOLUME_PID > /tmp/osd.pid
kill $VOLUME_PID2 1>/dev/null 2>&1
