#!/bin/bash

#if [ -d /etc/X11/xinit/xinitrc.d ]; then
#    for f in /etc/X11/xinit/xinitrc.d/*; do
#        [ -x "$f" ] && . "$f"
#    done
#    unset f
#fi

# source infinality settings
[[ -x /etc/X11/xinit/xinitrc.d/infinality-settings ]] && source /etc/X11/xinit/xinitrc.d/infinality-settings

# turn on numlock
[[ -x /usr/bin/numlockx ]] && numlockx on

# disable touchpad when mouse detected
[[ $(ls /dev/input | grep mouse | wc -l) -gt 1 ]] && synclient TouchpadOff=1

# turn off bell
xset -b

# key repeat delay and rate
xset r rate 500 35

# disable screensaver
xset s 0 0

# PulseAudio
#[[ -z $(pgrep -xU $UID pulseaudio) ]] && pulseaudio --start
#
# apps
#[[ -z $(pgrep -xU $UID mpd) ]] && mpd ~/.config/mpd/mpd.conf
#[[ -z $(pgrep -xU $UID mpd-notify) ]] && mpd-notify &

exec i3
