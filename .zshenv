## environment variables
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
export EDITOR=gvim

### linux console colors (jwr dark) ###
if [ "$TERM" = "linux" ]; then
    echo -en "\e]P0000000" #black
    echo -en "\e]P85e5e5e" #darkgrey
    echo -en "\e]P18a2f58" #darkred
    echo -en "\e]P9cf4f88" #red
    echo -en "\e]P2287373" #darkgreen
    echo -en "\e]PA53a6a6" #green
    echo -en "\e]P3914e89" #darkyellow
    echo -en "\e]PBbf85cc" #yellow
    echo -en "\e]P4395573" #darkblue
    echo -en "\e]PC4779b3" #blue
    echo -en "\e]P55e468c" #darkmagenta
    echo -en "\e]PD7f62b3" #magenta
    echo -en "\e]P62b7694" #darkcyan
    echo -en "\e]PE47959e" #cyan
    echo -en "\e]P7899ca1" #lightgrey
    echo -en "\e]PFc0c0c0" #white
    clear # bring us back to default input colours
fi
