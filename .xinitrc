#!/bin/bash

if [ -d /etc/X11/xinit/xinitrc.d ]; then
    for f in /etc/X11/xinit/xinitrc.d/*; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

# source infinality settings
#[[ -f /etc/X11/xinit/xinitrc.d/infinality-settings.sh ]] && source /etc/X11/xinit/xinitrc.d/infinality-settings.sh

# turn on numlock
[[ -x /usr/bin/numlockx ]] && numlockx on

# configure touchpad
# TODO: move to /etc/X11/xorg.conf.d/ (or at least use xinput)
#synclient HorizTwoFingerScroll=1 &

# disable touchpad when mouse detected
[[ $(ls /dev/input | grep mouse | wc -l) -gt 1 ]] && xinput disable "SynPS/2 Synaptics TouchPad"

# turn off bell
xset -b

# key repeat delay and rate
xset r rate 500 35

# disable screensaver
xset s 0 0

exec i3
