#!/bin/bash

if [ ! -f /tmp/lock-screen.lock ]; then
    (touch /tmp/lock-screen.lock && xlock +description -mode blank -font "-*-dejavu sans-medium-r-normal-*-*-*-*-*-*-*-iso8859-1" -timeout 5 -dpmsstandby 5 -dpmssuspend 5 -dpmsoff 5 && rm -f /tmp/lock-screen.lock) &
else
    exit 0
fi

exit 0
