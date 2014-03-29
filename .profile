umask 0077

## set up session environment
# export other directories to PATH
PATH=$HOME/bin:$HOME/Scripts:$PATH

# default applications
export TERMINAL=tinyterm
export BROWSER=firefox
export EDITOR=vim
#export PAGER="less -j4aRi"
export PAGER=vimpager
export VIMPAGER_RC=~/.config/vimpagerrc
export SUDO_ASKPASS="/usr/lib/ssh/gnome-ssh-askpass2"

# for GTK styles in Qt
export GTK2_RC_FILES=$HOME/.gtkrc-2.0

# setup default dirs
[ "$XDG_CACHE_HOME" ] || export XDG_CACHE_HOME="$HOME/.cache"
[ "$XDG_CONFIG_HOME" ] || export XDG_CONFIG_HOME="$HOME/.config"
[ "$XDG_DATA_HOME" ] || export XDG_DATA_HOME="$HOME/.local/share"

# hacks to respect XDG_CONFIG_HOME
export VIMINIT='let $MYVIMRC="$XDG_CONFIG_HOME/vim/vimrc" | source $MYVIMRC'
export IMAPFILTER_HOME="$XDG_CONFIG_HOME/imapfilter"
export MPV_HOME="$XDG_CONFIG_HOME/mpv"

# hacks to respect XDG_CACHE_HOME
export CCACHE_DIR="$XDG_CACHE_HOME/ccache"

# socket paths - temporary fix until systemd sets this automatically (or until this is the default path for dbus)
export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$UID/bus

# video acceleration (radeon)
export LIBVA_DRIVER_NAME=vdpau
export VDPAU_DRIVER=r600

# autostart systemd default session on tty1
#if [[ "$(tty)" == '/dev/tty1' ]]; then
#    if [[ -z $(pgrep -U $UID systemd) ]]; then
#        exec /usr/lib/systemd/systemd --user
#    fi
#fi

# autostart X session on tty1
if [[ "$(tty)" == '/dev/tty1' ]]; then
    exec xinit -- /usr/bin/Xorg :0 -nolisten tcp -noreset vt1
fi
