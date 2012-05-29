#!/bin/bash

value=`xset -q|sed -ne 's/^[ ]*Monitor is //p'`

if [ $value == 'On' ]; then
    xset dpms force off
else
    xset dpms force on
fi
