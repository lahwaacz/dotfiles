#!/bin/sh

case $1 in
    VOLUP)
        volume=$(amixer set Master 5%+ | grep 'Mono: Playback' | awk '{$vol=substr($4,2); i=index($vol,"%"); $vol=substr($vol,1,i-1); print $vol}')
        color="green"
        ;;
    VOLDN)
        volume=$(amixer set Master 5%- | grep 'Mono: Playback' | awk '{$vol=substr($4,2); i=index($vol,"%"); $vol=substr($vol,1,i-1); print $vol}')
        color="green"
        ;;
    MUTE)
        volume=$(amixer set Master toggle | grep 'Mono: Playback' | awk '{$vol=substr($4,2); i=index($vol,"%"); $vol=substr($vol,1,i-1); print $vol}')

        # test if on or off
        amixer get Master,0 |grep 'Mono: Playback' |grep -F [on] >/dev/null
        if [ "$?" -ne 0 ]; then
            color="red"
            volume="0"
        else
            color="green"
        fi
        ;;
esac

osd_cat -o 700 -A center -f -misc-fixed-medium-r-semicondensed--*-180-*-*-c-*-*-* -d 2 -b percentage -P $volume -c $color -T "Volume: $volume%"&
VOLUME_PID=$!
VOLUME_PID2=`cat /tmp/osd.pid`
echo $VOLUME_PID > /tmp/osd.pid
kill $VOLUME_PID2 1>/dev/null 2>&1
