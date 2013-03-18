#!/bin/zsh

## colored man pages
man() {
    env \
    LESS_TERMCAP_mb=$(printf "\e[1;31m") \
    LESS_TERMCAP_md=$(printf "\e[1;31m") \
    LESS_TERMCAP_me=$(printf "\e[0m") \
    LESS_TERMCAP_se=$(printf "\e[0m") \
    LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
    LESS_TERMCAP_ue=$(printf "\e[0m") \
    LESS_TERMCAP_us=$(printf "\e[1;32m") \
    man "$@"
}


## lock all sessions when inactive for 300 seconds if in tty
#export TMOUT=300
#function TRAPALRM() { 
#    if [[ $(tty) != *pts* ]]; then
#        vlock
#    fi
#}


## h -- grep history
h() {
    fc -l 0 -1 | sed -n "/$1/s/^ */!/p" | tail -n 30
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
    tree -CR --noreport $HOME/.notes
}

function _n() {
    _description notes expl "Existing notes"
    _files "$expl[@]" -W ~/.notes
    return 0
}

compdef _n n
