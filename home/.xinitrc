#!/bin/bash

if [ -f ~/.Xmodmap ]; then
    (sleep 5 && xmodmap ~/.Xmodmap) &
fi

# Source scripts in /etc/X11/xinit/xinitrc.d/
if [ -d /etc/X11/xinit/xinitrc.d ]; then
    for f in /etc/X11/xinit/xinitrc.d/*; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

if [ -x /usr/bin/numlockx ]; then
    numlockx on
fi

exec ck-launch-session $1
