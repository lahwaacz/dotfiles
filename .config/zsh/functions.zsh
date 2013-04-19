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
    fc -l 0 -1 | sed -n "/$1/s/^ */!/p" | tail -n 50
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
    find $HOME/.notes/ -print0 | sort -z | xargs -0 ls -d --color=always | sed "1n; s|$HOME/.notes/|    ./|g; s|\./.*/|    ./|g; s|\./||g"
    # sed: skip first line; replace top-level directory with './'; replace '\./.*/' with '    ./'; delete all occurences of '\./'
}

function _n() {
    _description notes expl "Existing notes"
    _files "$expl[@]" -W ~/.notes
    return 0
}

compdef _n n


## frequently used pacman commands
orphans() {
    if [[ ! -n $(pacman -Qdt) ]]; then 
        echo "no orphans to remove"
    else 
        sudo pacman -Rnsc $(pacman -Qdtq)
    fi
}


## extended cd -- from http://zshwiki.org/home/examples/functions
# This version does:
#   cd /etc/fstab -> cd /etc
#   corrections on the given dirname (if directory could not be found)
#   all(?) other possible invocations of the builtin 'cd'

function smart_cd () {
  if [[ -f $1 ]] ; then
    [[ ! -e ${1:h} ]] && return 1
    print correcting ${1} to ${1:h}
    builtin cd ${1:h}
  else
    builtin cd ${1}
  fi
}

function cd () {
  setopt localoptions
  setopt extendedglob
  local approx1 ; approx1=()
  local approx2 ; approx2=()
  if (( ${#*} == 0 )) || [[ ${1} = [+-]* ]] ; then
    builtin cd "$@"
  elif (( ${#*} == 1 )) ; then
    approx1=( (#a1)${1}(N) )
    approx2=( (#a2)${1}(N) )
    if [[ -e ${1} ]] ; then
      smart_cd ${1}
    elif [[ ${#approx1} -eq 1 ]] ; then
      print correcting ${1} to ${approx1[1]}
      smart_cd ${approx1[1]}
    elif [[ ${#approx2} -eq 1 ]] ; then
      print correcting ${1} to ${approx2[1]}
      smart_cd ${approx2[1]}
    else
      print couldn\'t correct ${1}
    fi
  elif (( ${#*} == 2 )) ; then
    builtin cd $1 $2
  else
    print cd: too many arguments
  fi
}
