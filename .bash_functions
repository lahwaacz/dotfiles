#! /usr/bin/bash

## colored man pages
function man() {
    env \
        LESS_TERMCAP_mb=$'\e[01;31m' \
        LESS_TERMCAP_md=$'\e[01;31m' \
        LESS_TERMCAP_me=$'\e[0m' \
        LESS_TERMCAP_se=$'\e[0m' \
        LESS_TERMCAP_so=$'\e[01;44;33m' \
        LESS_TERMCAP_ue=$'\e[0m' \
        LESS_TERMCAP_us=$'\e[01;32m' \
            man "$@"
}


## Print man pages 
function manp() { man -t "$@" | lpr -pPrinter; }


## Create pdf of man page - requires ghostscript and mimeinfo
function manpdf() { man -t "$@" | ps2pdf - /tmp/manpdf_$1.pdf && xdg-open /tmp/manpdf_$1.pdf ;}


## lock all sessions when inactive for 300 seconds if in tty
#export TMOUT=300
#function TRAPALRM() { 
#    if [[ $(tty) != *pts* ]]; then
#        vlock
#    fi
#}


## h -- grep history
function h() {
    fc -l 1 -1 | sed -n "/$1/s/^ */!/p" | tail -n 50
}
alias h=' h'


## fortune message
#if [[ $(setopt | grep login) == "login" ]]; then
#    fortune ferengi_rules_of_acquisition
#    echo
#fi


## simple notes taking utility
function n() {
    ${EDITOR:-vim} $HOME/.notes/"$*"
}

function nls() {
    find $HOME/.notes/ -print0 | sort -z | xargs -0 ls -d --color=always | sed "1n; s|$HOME/.notes/|    ./|g; s|\./.*/[^$]|    ./|g; s|\./||g"
    # sed: skip first line; replace top-level directory with './'; replace '\./.*/[^$]' with '    ./'; delete all occurences of '\./'
}

# TAB completion for notes
function _n() {
    local files=($HOME/.notes/**/"$2"*)
    [[ -e ${files[0]} ]] && COMPREPLY=( "${files[@]##~/.notes/}" )
}
complete -o default -F _n n


## frequently used pacman commands
function orphans() {
    if [[ ! -n $(pacman -Qdt) ]]; then 
        echo "no orphans to remove"
    else 
        sudo pacman -Rnsc $(pacman -Qdtq)
    fi
}


## custom cd function
# implements 'autopushd'
# 'cd -' flips last visited dir (exactly what pushd without aruments does)
function cd() {
    if [[ $# -eq 0 ]]; then
        builtin pushd "$HOME"
    elif [[ $# -eq 1 ]]; then
        if [[ "$1" == "-" ]]; then
            builtin pushd
        elif [[ -f "$1" ]]; then
            builtin pushd $(dirname "$1")
        else
            builtin pushd "$1"
        fi
    else
        echo "cd: Too many arguments"
    fi
}
