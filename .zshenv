# setup default dirs
[ "$XDG_CACHE_HOME" ] || export XDG_CACHE_HOME="$HOME/.cache"
[ "$XDG_CONFIG_HOME" ] || export XDG_CONFIG_HOME="$HOME/.config"
[ "$XDG_DATA_HOME" ] || export XDG_DATA_HOME="$HOME/.local/share"

export COLORFGBG=default,default,default    # I think tmux sets this wrong
export SYSTEMD_PAGER="less -j4aR"

# for GTK styles in Qt
export GTK2_RC_FILES=$HOME/.gtkrc-2.0

# gpg-agent sockets
if [ -f /run/user/1000/gpg-agent-info ]; then
    source /run/user/1000/gpg-agent-info
    export GPG_AGENT_INFO
    export SSH_AUTH_SOCK
fi

# socket paths
export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$UID/dbus/user_bus_socket   # temporal fix until systemd sets this automatically (or until this is the default path for dbus)
#export RXVT_SOCKET=$XDG_RUNTIME_DIR/urxvtd-socket

# default applications
export TERMINAL=tinyterm
export BROWSER=dwb
export EDITOR=vim
export PAGER="less -j4aR"
