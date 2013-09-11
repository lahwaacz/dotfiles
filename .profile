umask 0077

## set up session environment
# export other directories to PATH
PATH=$HOME/bin:$HOME/Scripts:$PATH

# default applications
export TERMINAL=tinyterm-wrapper
export BROWSER=dwb
export EDITOR=vim
export PAGER="less -j4aRi"

# for GTK styles in Qt
export GTK2_RC_FILES=$HOME/.gtkrc-2.0

# setup default dirs
[ "$XDG_CACHE_HOME" ] || export XDG_CACHE_HOME="$HOME/.cache"
[ "$XDG_CONFIG_HOME" ] || export XDG_CONFIG_HOME="$HOME/.config"
[ "$XDG_DATA_HOME" ] || export XDG_DATA_HOME="$HOME/.local/share"

# socket paths - temporary fix until systemd sets this automatically (or until this is the default path for dbus)
export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$UID/dbus/user_bus_socket

# video acceleration (radeon)
export LIBVA_DRIVER_NAME=vdpau
export VDPAU_DRIVER=r600

# autostart systemd default session on tty1
if [[ "$(tty)" == '/dev/tty1' ]]; then
    if [[ -z $(pgrep -U $UID systemd) ]]; then
        exec /usr/lib/systemd/systemd --user
    fi
fi
