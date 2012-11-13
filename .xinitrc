#!/bin/bash

export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
export BROWSER=chromium  # required by xdg-open to work `properly`

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

# turn off beep
xset -b

# export umask
umask 0077

exec $1
