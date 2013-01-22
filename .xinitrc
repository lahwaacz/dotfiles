#!/bin/bash

export GTK2_RC_FILES="$HOME/.gtkrc-2.0"     # for GTK styles in Qt
export EDITOR=qvim   # required by yaourt
export BROWSER=chromium

# Source scripts in /etc/X11/xinit/xinitrc.d/
if [ -d /etc/X11/xinit/xinitrc.d ]; then
    for f in /etc/X11/xinit/xinitrc.d/*; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

# turn on numlock
if [ -x /usr/bin/numlockx ]; then
    numlockx on
fi

# disable touchpad when mouse detected
if [ $(ls /dev/input | grep mouse | wc -l) -gt 1 ]; then
    synclient TouchpadOff=1
fi

# turn off beep
xset -b

# export umask
umask 0077

# systemd user session
#systemd --user --unit=graphical.target &

# init external monitor
/home/lahwaacz/bin/initscreen.sh

setxkbmap cz    # just in case...

exec $1
