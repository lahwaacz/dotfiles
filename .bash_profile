# shellcheck shell=bash

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
export BROWSER=librewolf
export EDITOR=nvim
export DIFFPROG="nvim -d"
export PAGER="less -FRXMKij4"
export SYSTEMD_LESS=FRXMKij4   # omit 'S' to disable "chopping" long lines
export QUOTING_STYLE=literal    # http://unix.stackexchange.com/questions/258679/why-is-ls-suddenly-surrounding-items-with-spaces-in-single-quotes
[[ $(command -v bat) ]] && [[ $(command -v batmanpager) ]] && export MANPAGER=batmanpager

# detect the current DRM driver (grep based on https://unix.stackexchange.com/a/207175)
driver=$(grep -oP 'DRIVER=\K\w+' /sys/class/drm/card1/device/uevent)

# video acceleration
if [[ "$driver" == "nvidia" ]]; then
    export LIBVA_DRIVER_NAME=nvidia
else
    export LIBVA_DRIVER_NAME=iHD
fi

#MAKEFLAGS=-j$(grep "core id" /proc/cpuinfo | sort -u | wc -l)  # counts physical cores
MAKEFLAGS=-j$(grep "processor" /proc/cpuinfo | sort -u | wc -l)  # counts all cores
export MAKEFLAGS

# setup default dirs
[ "$XDG_CACHE_HOME" ] || export XDG_CACHE_HOME="$HOME/.cache"
[ "$XDG_CONFIG_HOME" ] || export XDG_CONFIG_HOME="$HOME/.config"
[ "$XDG_DATA_HOME" ] || export XDG_DATA_HOME="$HOME/.local/share"
[ "$XDG_STATE_HOME" ] || export XDG_STATE_HOME="$HOME/.local/state"

# see https://github.com/grawity/dotfiles/blob/master/.dotfiles.notes

# hacks to respect XDG_CONFIG_HOME
export IPYTHONDIR="$XDG_CONFIG_HOME/ipython"
export NOTMUCH_CONFIG="$XDG_CONFIG_HOME/notmuch-config"
export INPUTRC="$XDG_CONFIG_HOME/inputrc"
export JUPYTER_CONFIG_DIR="$XDG_CONFIG_HOME/jupyter"
export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="$XDG_CONFIG_HOME/java"
export ANSIBLE_CONFIG="${XDG_CONFIG_HOME}/ansible.cfg"
export SCREENRC="$XDG_CONFIG_HOME"/screenrc

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
export SCREENDIR="$XDG_RUNTIME_DIR/screen"
export W3M_DIR="$XDG_RUNTIME_DIR/w3m"

export UNISON="$XDG_DATA_HOME/unison"

export TEXMFHOME=$XDG_DATA_HOME/texmf
export TEXMFVAR=$XDG_CACHE_HOME/texlive/texmf-var
export TEXMFCONFIG=$XDG_CONFIG_HOME/texlive/texmf-config

# source bashrc in interactive login shells (SSH)
# shellcheck source=/dev/null
[[ -f ~/.bashrc ]] && source ~/.bashrc

# autostart X or Wayland session on tty1, unless $XDG_CURRENT_DESKTOP is already set (e.g. SDDM sources this file before starting the session)
if [[ "$(tty)" == "/dev/tty1" ]] && [[ -z "$XDG_CURRENT_DESKTOP" ]]; then
    if [[ $(command -v sway) ]]; then
        export QT_QPA_PLATFORM=wayland
        export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
        systemctl --user import-environment QT_QPA_PLATFORM QT_WAYLAND_DISABLE_WINDOWDECORATION
        export GOLDENDICT_FORCE_WAYLAND=1
        # sway does not set $XDG_CURRENT_DESKTOP
        export XDG_CURRENT_DESKTOP=sway
        exec sway
    elif [[ $(command -v xinit) ]]; then
        # i3 sets this, but exporting it manually makes the condition above work
        export XDG_CURRENT_DESKTOP=i3
        exec xinit -- :0
    fi
fi
