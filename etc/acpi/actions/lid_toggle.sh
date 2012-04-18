#!/bin/bash

export DISPLAY=":0.0"
export XAUTHORITY="/home/lahwaacz/.Xauthority"

logger "toggle LID called"

value=`xset -q|sed -ne 's/^[ ]*Monitor is //p'`

if [ $value == 'On' ]; then
    xset dpms force off
else
    xset dpms force on
fi
