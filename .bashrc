# check for interactive
[[ $- = *i* ]] || return

# bash options ------------------------------------
set -o vi                   # Vi mode
set -o noclobber            # do not overwrite files
shopt -s autocd             # change to named directory
shopt -s cdable_vars        # if cd arg is not valid, assumes its a var defining a dir
shopt -s cdspell            # autocorrects cd misspellings
shopt -s checkwinsize       # update the value of LINES and COLUMNS after each command if altered
shopt -s cmdhist            # save multi-line commands in history as single line
shopt -s histappend         # do not overwrite history
shopt -s dotglob            # include dotfiles in pathname expansion
shopt -s expand_aliases     # expand aliases
shopt -s extglob            # enable extended pattern-matching features
shopt -s globstar           # recursive globbing…
shopt -s progcomp           # programmable completion
shopt -s hostcomplete       # attempt hostname expansion when @ is at the beginning of a word
shopt -s nocaseglob         # pathname expansion will be treated as case-insensitive

set bell-style visual       # visual bell

# function setting prompt string
bash_prompt() {
    # some colors
    local color_reset="\033[00m"
    local red="\033[01;31m"
    local green="\033[01;32m"
    local yellow="\033[01;33m"
    local blue="\033[01;34m"

    # red for root, green for others
    local host_color=$(if [[ $UID == 0 ]]; then echo "$red"; else echo "$green"; fi)

    # colorized return value of last command
    local ret="\$(if [[ \$? == 0 ]]; then echo \"\[$green\]\$?\"; else echo \"\[$red\]\$?\"; fi)"

    # blue for writable directories, yellow for non-writable directories
    local dir="\$(if [[ -w \$PWD ]]; then echo \"\[$blue\]\"; else echo \"\[$yellow\]\"; fi)\w"

    # put it all together
    PS1="$ret \[$host_color\]\u@\h\[$color_reset\]:$dir\[$color_reset\]\$ "
}
bash_prompt

# set history variables 
unset HISTFILESIZE
HISTSIZE=100000
HISTCONTROL=ignoredups:ignorespace
# share history across all terminals
PROMPT_COMMAND="history -a; history -c; history -r"
#export HISTSIZE PROMPT_COMMAND

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

#if [[ "$TERM" =~ ".*256color.*" && -f ~/.dircolors.256colors ]]; then
if [[ "$TERM" != "linux" && -f ~/.dircolors.256colors ]]; then
    eval $(dircolors ~/.dircolors.256colors)
elif [ -f ~/.dircolors ]; then
    eval $(dircolors ~/.dircolors)
fi

# load bash-completion
[ -r /usr/share/bash-completion/bash_completion ] && source /usr/share/bash-completion/bash_completion

## Aliases
# enable color support of ls and also add handy aliases
if [ -x /bin/dircolors ]; then
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alFh'
alias la='ls -A'
alias l='ls -CF'

# source aliases from file
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# useful functions
man() {
    env \
        LESS_TERMCAP_mb=$(printf "\e[1;37m") \
        LESS_TERMCAP_md=$(printf "\e[1;37m") \
        LESS_TERMCAP_me=$(printf "\e[0m") \
        LESS_TERMCAP_se=$(printf "\e[0m") \
        LESS_TERMCAP_so=$(printf "\e[1;47;30m") \
        LESS_TERMCAP_ue=$(printf "\e[0m") \
        LESS_TERMCAP_us=$(printf "\e[0;36m") \
            man "$@"
}

orphans() {
    if [[ ! -n $(pacman -Qdtq) ]]; then
        echo "no orphans to remove"
    else
        sudo pacman -Rnsc $(pacman -Qdtq)
    fi
}

export EDITOR=vim
