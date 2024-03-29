#! /usr/bin/bash

## h -- grep history
function h() {
    fc -l 1 -1 | sed -n "/$1/s/^ */!/p" | tail -n 50
}
alias h=' h'


## simple notes taking utility
function n() {
    local dir="$HOME/Documents/notes/"
    local files=( "$@" )
    # prepend $dir to each file
    files=( "${files[@]/#/$dir}" )
    ${EDITOR:-vim} -p "${files[@]}"
}

function nls() {
    find $HOME/Documents/notes/ -print0 | sort -z | xargs -0 ls -d --color=always | sed "1n; s|$HOME/Documents/notes/|    ./|g; s|\./.*/[^$]|    ./|g; s|\./||g"
    # sed: skip first line; replace top-level directory with './'; replace '\./.*/[^$]' with '    ./'; delete all occurences of '\./'
}

# TAB completion for notes
function _n() {
    local files=($HOME/Documents/notes/**/"$2"*)
    [[ -e ${files[0]} ]] && COMPREPLY=( "${files[@]##~/Documents/notes/}" )
}
complete -o default -F _n n


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
    sudo pacman -Syu $@
    local ret=$?
    if [[ $ret -ne 0 ]]; then
        return $ret
    fi
    if [[ $(command -v checkservices) ]]; then
        sudo checkservices
    fi
}
alias suy='syu'
