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
shopt -s globstar           # recursive globbing
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
    local magenta="\033[01;35m"

    # green is the default prompt color
    local host_color="$green"
    # red for root
    [[ $UID == 0 ]] && host_color="$red"
    # cyan for SSH sessions
    [[ -n "$SSH_CONNECTION" ]] && host_color="$cyan"

    # colorized return value of last command
    local ret="\$(if [[ \$? == 0 ]]; then echo \"\[$green\]\$?\"; else echo \"\[$red\]\$?\"; fi)"

    # blue for writable directories, yellow for non-writable directories
    local dir="\$(if [[ -w \$PWD ]]; then echo \"\[$blue\]\"; else echo \"\[$yellow\]\"; fi)\w"

    # configuration for __git_ps1 function
    GIT_PS1_SHOWDIRTYSTATE=1
    GIT_PS1_SHOWSTASHSTATE=1
    GIT_PS1_SHOWUPSTREAM="auto"

    # check if we're on local filesystem
    local local_fs=$(df --output=fstype . | tail -n +2)

    if [[ "$local_fs" == "fuse.sshfs" ]]; then
        # skip git prompt on remote paths
        PS1="$ret \[$host_color\]\u@\h\[$color_reset\]:$dir\[$color_reset\]\$ "
    else
        PS1="$ret \[$host_color\]\u@\h\[$color_reset\]:$dir\[$magenta\]\$(__git_ps1)\[$color_reset\]\$ "
    fi
}
# Arch
if [[ -r /usr/share/git/completion/git-prompt.sh ]]; then
    source /usr/share/git/completion/git-prompt.sh
# Ubuntu
elif [[ -r /etc/bash_completion.d/git-prompt ]]; then
    source /etc/bash_completion.d/git-prompt
fi
bash_prompt

# set history variables 
unset HISTFILESIZE
HISTSIZE=100000
HISTCONTROL=ignoredups:ignorespace
# share history across all terminals
#PROMPT_COMMAND="history -a; history -c; history -r"
#PROMPT_COMMAND="history -a"
# export $PWD in window title
PROMPT_COMMAND='history -a; echo -ne "\033]0;$PWD\007"'
#export HISTSIZE PROMPT_COMMAND

# make less more friendly for non-text input files, see lesspipe(1)
[[ -x /usr/bin/lesspipe ]] && eval "$(SHELL=/bin/sh lesspipe)"

#if [[ "$TERM" =~ ".*256color.*" && -f ~/.dircolors.256colors ]]; then
if [[ "$TERM" != "linux" && -f "$XDG_CONFIG_HOME/dircolors.256color" ]]; then
    eval $(dircolors "$XDG_CONFIG_HOME/dircolors.256color")
elif [[ -f "$XDG_CONFIG_HOME/dircolors" ]]; then
    eval $(dircolors "$XDG_CONFIG_HOME/dircolors")
fi

## source useful files
[[ -r /usr/share/bash-completion/bash_completion ]] && source /usr/share/bash-completion/bash_completion
[[ -f ~/.bash_aliases ]] && source ~/.bash_aliases
[[ -f ~/.bash_functions ]] && source ~/.bash_functions
