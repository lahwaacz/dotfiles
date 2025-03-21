#! /usr/bin/bash

## h -- grep history
function h() {
    fc -l 1 -1 | sed -n "/$1/s/^ */!/p" | tail -n 50
}
alias h=' h'


## simple notes taking utility
function n() {
    local dir="$HOME/Documents/Notes/"
    (
        builtin cd "$dir"
        nvim -c NvimTreeOpen todo.md
    )
}


## frequently used pacman commands
function orphans() {
    if [[ ! -n $(pacman -Qdtt) ]]; then 
        echo "no orphans to remove"
    else
        sudo pacman -Rnsc $(pacman -Qdttq)
    fi
}


## custom cd function
# implements 'autopushd'
# 'cd -' flips last visited dir (exactly what pushd without aruments does)
function cd() {
    if [[ $# -eq 0 ]]; then
        builtin pushd "$HOME"
    else
        # remove '--' from the parameters
        if [[ "$1" == "--" ]]; then
            set -- "${@:2:$#}"
        fi

        if [[ $# -eq 1 ]]; then
            if [[ "$1" == "-" ]]; then
                builtin pushd
            elif [[ -f "$1" ]]; then
                # auxiliary variable is necessary to handle spaces in the path
                local dir
                dir=$(dirname "$1")
                builtin pushd -- "$dir"
            else
                builtin pushd -- "$1"
            fi
        else
            echo "cd: Too many arguments"
        fi
    fi
}


## path synchronization for lf
# (reference: https://github.com/gokcehan/lf/blob/master/etc/lfcd.sh)
function lf {
    tempfile="$(mktemp -t lf-cd.XXXXXX)"
    command lf -last-dir-path="$tempfile" "${@:-$(pwd)}"
    if [[ -f "$tempfile" ]] && [[ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]]; then
        cd -- "$(cat "$tempfile")"
    fi
    rm -f -- "$tempfile"
}


## system upgrade
function syu {
    sudo pacman -Syu "$@"
    local ret=$?
    if [[ $ret -ne 0 ]]; then
        return $ret
    fi
    if command -v checkservices > /dev/null; then
        echo "==> Running checkservices"
        sudo checkservices
    fi
    if command -v flatpak > /dev/null; then
        echo "==> Running flatpak update"
        flatpak update
        echo "==> Running flatpak --user update"
        flatpak --user update
    fi
}
alias suy='syu'
