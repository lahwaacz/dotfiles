#!/bin/bash

usermodmap=$HOME/.Xmodmap
if [ -f $usermodmap ]; then
    xmodmap $usermodmap
fi

exec ck-launch-session dbus-launch $1
