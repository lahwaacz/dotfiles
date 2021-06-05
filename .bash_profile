#umask 0077
umask 0022

## set up session environment
# export other directories to PATH
PATH=$HOME/bin:$PATH:$HOME/Scripts

# TNL
export PATH="$HOME/.local/bin:$PATH"
export LD_LIBRARY_PATH="$HOME/.local/lib:$LD_LIBRARY_PATH"
# compilers (-L and -I)
export LIBRARY_PATH="$HOME/.local/lib:$LIBRARY_PATH"
export CPATH="$HOME/.local/include:$CPATH"

export PKG_CONFIG_PATH="$HOME/.local/lib/pkgconfig:$HOME/.local/share/pkgconfig:$PKG_CONFIG_PATH"

# default applications
export TERMINAL=termite
export BROWSER=qutebrowser
export EDITOR=vim
export DIFFPROG=vimdiff
export PAGER="less -FRXMKij4"
[[ $(command -v bat) ]] && [[ $(command -v batmanpager) ]] && export MANPAGER=batmanpager
[[ $(command -v lxqt-openssh-askpass) ]] && export SUDO_ASKPASS=$(command -v "lxqt-openssh-askpass")

export LIBVA_DRIVER_NAME=vdpau  # video acceleration
export SYSTEMD_LESS=FRXMKij4   # omit 'S' to disable "chopping" long lines
export CCACHE_PATH="/usr/bin"   # tell ccache to only use compilers here
export QUOTING_STYLE=literal    # http://unix.stackexchange.com/questions/258679/why-is-ls-suddenly-surrounding-items-with-spaces-in-single-quotes
export RANGER_LOAD_DEFAULT_RC=FALSE

# count physical cores on my laptop, all cores elsewhere
if [[ "$HOSTNAME" == "jlknb" ]]; then
    export MAKEFLAGS=-j$(grep "core id" /proc/cpuinfo | sort -u | wc -l)
else
    export MAKEFLAGS=-j$(grep "processor" /proc/cpuinfo | sort -u | wc -l)
fi

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
export ASPROOT="$XDG_CONFIG_HOME/asp"
export JUPYTER_CONFIG_DIR="$XDG_CONFIG_HOME/jupyter"
export UNISON="$XDG_DATA_HOME/unison"

# hacks to respect XDG_CACHE_HOME
export CCACHE_DIR="$XDG_CACHE_HOME/ccache"
export DISTCC_DIR="$XDG_CACHE_HOME/distcc"
export PYLINTHOME="$XDG_CACHE_HOME/pylint"
export LESSHISTFILE="$XDG_CACHE_HOME/less_history"
export MYSQL_HISTFILE="$XDG_CACHE_HOME/mysql_history"
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/startup.py"   # ~/.python_history is overridden there
export __GL_SHADER_DISK_CACHE_PATH="$XDG_CACHE_HOME/nv"
export CUDA_CACHE_PATH="$XDG_CACHE_HOME/nv"
export ASPCACHE="$XDG_CACHE_HOME/asp"
export ANSIBLE_LOCAL_TEMP="$XDG_CACHE_HOME/ansible/tmp"

# source bashrc in interactive login shells (SSH)
[[ -f ~/.bashrc ]] && source ~/.bashrc

# autostart X session on tty1
if [[ "$(tty)" == "/dev/tty1" ]] && [[ $(command -v xinit) ]]; then
    if [[ $(command -v sway) ]]; then
        # disable nvidia GPU first, otherwise sway would just load the nvidia module
        sudo nvidia-switch off
        #export QT_QPA_PLATFORM=wayland-egl   # EGL seems to always try to use the nvidia GPU
        export QT_QPA_PLATFORM=wayland
        export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
        systemctl --user import-environment QT_QPA_PLATFORM QT_WAYLAND_DISABLE_WINDOWDECORATION
        exec sway
    elif [[ $(command -v xinit) ]]; then
        exec xinit -- :0
    fi
fi
