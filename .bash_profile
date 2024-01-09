#umask 0077
umask 0022

## set up session environment
# export other directories to PATH
PATH=$HOME/bin:$PATH:$HOME/Scripts

# TNL
export PATH="$HOME/.local/bin:$PATH"
export LD_LIBRARY_PATH="$HOME/.local/lib:$LD_LIBRARY_PATH"
# compilers (-L and -isystem)
export LIBRARY_PATH="$HOME/.local/lib:$LIBRARY_PATH"
export C_INCLUDE_PATH="$HOME/.local/include"
export CPLUS_INCLUDE_PATH="$HOME/.local/include"

export PKG_CONFIG_PATH="$HOME/.local/lib/pkgconfig:$HOME/.local/share/pkgconfig:$PKG_CONFIG_PATH"

# default applications
export TERMINAL=alacritty
export BROWSER=qutebrowser
export EDITOR=vim
export DIFFPROG=vimdiff
export PAGER="less -FRXMKij4"
[[ $(command -v bat) ]] && [[ $(command -v batmanpager) ]] && export MANPAGER=batmanpager

export LIBVA_DRIVER_NAME=vdpau  # video acceleration
export SYSTEMD_LESS=FRXMKij4   # omit 'S' to disable "chopping" long lines
export QUOTING_STYLE=literal    # http://unix.stackexchange.com/questions/258679/why-is-ls-suddenly-surrounding-items-with-spaces-in-single-quotes

#export MAKEFLAGS=-j$(grep "core id" /proc/cpuinfo | sort -u | wc -l)  # counts physical cores
export MAKEFLAGS=-j$(grep "processor" /proc/cpuinfo | sort -u | wc -l)  # counts all cores

# setup default dirs
[ "$XDG_CACHE_HOME" ] || export XDG_CACHE_HOME="$HOME/.cache"
[ "$XDG_CONFIG_HOME" ] || export XDG_CONFIG_HOME="$HOME/.config"
[ "$XDG_DATA_HOME" ] || export XDG_DATA_HOME="$HOME/.local/share"
[ "$XDG_STATE_HOME" ] || export XDG_STATE_HOME="$HOME/.local/state"

# see https://github.com/grawity/dotfiles/blob/master/.dotfiles.notes

# hacks to respect XDG_CONFIG_HOME
export VIMINIT='let $MYVIMRC="$XDG_CONFIG_HOME/vim/vimrc" | source $MYVIMRC'
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc-2.0"   # for GTK styles in Qt
export GIMP2_DIRECTORY="$XDG_CONFIG_HOME/gimp"
export IPYTHONDIR="$XDG_CONFIG_HOME/ipython"
export NOTMUCH_CONFIG="$XDG_CONFIG_HOME/notmuch-config"
export INPUTRC="$XDG_CONFIG_HOME/inputrc"
export JUPYTER_CONFIG_DIR="$XDG_CONFIG_HOME/jupyter"
export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME/java"
export ANSIBLE_CONFIG="${XDG_CONFIG_HOME}/ansible.cfg"

# hacks to respect XDG_CACHE_HOME
export __GL_SHADER_DISK_CACHE_PATH="$XDG_CACHE_HOME/nv"
export CUDA_CACHE_PATH="$XDG_CACHE_HOME/nv"
export ANSIBLE_LOCAL_TEMP="$XDG_CACHE_HOME/ansible/tmp"
export ANSIBLE_GALAXY_CACHE_DIR="${XDG_CACHE_HOME}/ansible/galaxy_cache"

# hacks to respect XDG_STATE_HOME
export LESSHISTFILE="$XDG_STATE_HOME/less_history"
export MYSQL_HISTFILE="$XDG_STATE_HOME/mysql_history"
export PSQL_HISTORY="$XDG_STATE_HOME/psql_history"
export PYTHONSTARTUP="$XDG_CONFIG_HOME/python/startup.py"   # ~/.python_history is overridden there

export UNISON="$XDG_DATA_HOME/unison"

export TEXMFHOME=$XDG_DATA_HOME/texmf
export TEXMFVAR=$XDG_CACHE_HOME/texlive/texmf-var
export TEXMFCONFIG=$XDG_CONFIG_HOME/texlive/texmf-config

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
