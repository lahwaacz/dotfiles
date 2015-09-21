#umask 0077
umask 0022

## set up session environment
# export other directories to PATH
PATH=$HOME/bin:$HOME/Scripts:$PATH

# TNL
export PATH="$HOME/local/bin:$PATH"
export LD_LIBRARY_PATH="$HOME/local/lib:$LD_LIBRARY_PATH"

# default applications
export TERMINAL=tinyterm
export BROWSER=firefox
export EDITOR=vim
export DIFFPROG=vimdiff
#export PAGER="less -j4aRi"
export PAGER=vimpager
export SUDO_ASKPASS="/usr/lib/ssh/gnome-ssh-askpass2"

export LIBVA_DRIVER_NAME=vdpau  # video acceleration
export SYSTEMD_LESS=FRXMK   # omit 'S' to disable "chopping" long lines
export CCACHE_PATH="/usr/bin"   # tell ccache to only use compilers here
export SPICE_NOGRAB=1   # disable keyboard grabbing for spicec

# setup default dirs
[ "$XDG_CACHE_HOME" ] || export XDG_CACHE_HOME="$HOME/.cache"
[ "$XDG_CONFIG_HOME" ] || export XDG_CONFIG_HOME="$HOME/.config"
[ "$XDG_DATA_HOME" ] || export XDG_DATA_HOME="$HOME/.local/share"

# see https://github.com/grawity/dotfiles/blob/master/.dotfiles.notes

# hacks to respect XDG_CONFIG_HOME
export VIMINIT='let $MYVIMRC="$XDG_CONFIG_HOME/vim/vimrc" | source $MYVIMRC'
export VIMPAGER_RC="$XDG_CONFIG_HOME/vimpagerrc"
export IMAPFILTER_HOME="$XDG_CONFIG_HOME/imapfilter"
export MPV_HOME="$XDG_CONFIG_HOME/mpv"
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc-2.0"   # for GTK styles in Qt
export GIMP2_DIRECTORY="$XDG_CONFIG_HOME/gimp"
export IPYTHONDIR="$XDG_CONFIG_HOME/ipython"
export NOTMUCH_CONFIG="$XDG_CONFIG_HOME/notmuch-config"
export INPUTRC="$XDG_CONFIG_HOME/inputrc"
export GNUPGHOME="$XDG_CONFIG_HOME/gnupg"
export ASPROOT="$XDG_CONFIG_HOME/asp"

# hacks to respect XDG_CACHE_HOME
export CCACHE_DIR="$XDG_CACHE_HOME/ccache"
export DISTCC_DIR="$XDG_CACHE_HOME/distcc"
export PYLINTHOME="$XDG_CACHE_HOME/pylint"
export LESSHISTFILE="$XDG_CACHE_HOME/less_history"
export MYSQL_HISTFILE="$XDG_CACHE_HOME/mysql_history"
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/startup.py"   # ~/.python_history is overridden there
export __GL_SHADER_DISK_CACHE_PATH="$XDG_CACHE_HOME/nv"
export export CUDA_CACHE_PATH="$XDG_CACHE_HOME/nv"
export ASPCACHE="$XDG_CACHE_HOME/asp"

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
