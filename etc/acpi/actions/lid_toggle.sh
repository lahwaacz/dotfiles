#!/bin/bash

value=`xset -q|sed -ne 's/^[ ]*Monitor is //p'`

if [ $value == 'On' ]; then
    su $USER -c "lock-screen.sh"
    xset dpms force off
else
    xset dpms force on
fi
