#!/bin/bash

export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
export BROWSER=chromium  # required by xdg-open to work `properly`

if [ -f ~/.Xmodmap ]; then
    (xmodmap -verbose ~/.Xmodmap > /tmp/xmodmap.log 2>&1) &
fi
#xmodmap -verbose -e "clear Lock" -e "keycode 0x42 = Tab" -e "keycode 0x17 = Caps_Lock" > /tmp/xmodmap.log 2>&1

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
