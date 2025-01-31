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
# nocaseglob breaks pacman completion: https://bugs.archlinux.org/task/67808
#shopt -s nocaseglob         # pathname expansion will be treated as case-insensitive

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
    local cyan="\033[01;36m"

    # green for user
    local user_color="$green"
    # red for root
    [[ $UID == 0 ]] && user_color="$red"

    # green for local session
    local host_color="$green"
    # cyan for SSH sessions
    [[ -n "$SSH_CONNECTION" ]] && host_color="$cyan"

    # colorized return value of last command
    local ret="\$(if [[ \$? == 0 ]]; then echo \"\[$green\]\$?\"; else echo \"\[$red\]\$?\"; fi)"

    # blue for writable directories, yellow for non-writable directories
    local dir="\$(if [[ -w \$PWD ]]; then echo \"\[$blue\]\"; else echo \"\[$yellow\]\"; fi)\w"

    if [[ $(type -t "__git_ps1") == "function" ]]; then
        # configuration for __git_ps1 function
        GIT_PS1_SHOWDIRTYSTATE=1
        GIT_PS1_SHOWSTASHSTATE=1
        GIT_PS1_SHOWUPSTREAM="auto"

        # check if we're on local filesystem and skip git prompt on remote paths
        local git="\$(if [[ \"\$(df --output=fstype . | tail -n +2)\" != \"fuse.sshfs\" ]]; then __git_ps1; fi)"
    else
        local git=""
    fi

    PS1="$ret \[$user_color\]\u\[$host_color\]@\h\[$color_reset\]:$dir\[$magenta\]$git\[$color_reset\]\$ "
}
# Arch
if [[ -r /usr/share/git/completion/git-prompt.sh ]]; then
    source /usr/share/git/completion/git-prompt.sh
# Rocky 8.X
elif [[ -r /usr/share/git-core/contrib/completion/git-prompt.sh ]]; then
    source /usr/share/git-core/contrib/completion/git-prompt.sh
# Debian, Ubuntu
elif [[ -r /etc/bash_completion.d/git-prompt ]]; then
    source /etc/bash_completion.d/git-prompt
# others
elif [[ -r "$HOME/bin/git-prompt.sh" ]]; then
    source "$HOME/bin/git-prompt.sh"
fi
bash_prompt

# export $PWD in window title
PROMPT_COMMAND=('echo -ne "\033]0;$PWD\007"')

# set history variables 
unset HISTFILESIZE
HISTSIZE=100000
HISTCONTROL=ignoredups:ignorespace
# share history across all terminals
#PROMPT_COMMAND+=("history -a; history -c; history -r")
# update the $HISTFILE immediately after it is executed
PROMPT_COMMAND+=('history -a')

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

# set the right path to be used by the SSH agent, but do not override the existing value
# (e.g. set by SSH when agent forwarding is enabled)
export SSH_AUTH_SOCK="${SSH_AUTH_SOCK:-/run/user/$UID/gnupg/S.gpg-agent.ssh}"
# set up SSH agent to use gpg-agent -- needed to show the right pinentry when the
# user switches between console and X
if [[ -S "$SSH_AUTH_SOCK" ]] && [[ $UID != 0 ]]; then
    export GPG_TTY=$(tty)
    gpg-connect-agent updatestartuptty /bye >/dev/null
fi


# FIXME: i3 interferes with the inheritance of bash functions defined by lmod
if [[ "$DESKTOP_SESSION" =~ "i3" ]] && [[ -f /etc/profile.d/modules.sh ]]; then
    source /etc/profile.d/modules.sh
fi


# don't use sudo in vscode (it has a key logger)
if [[ "$TERM_PROGRAM" == "vscode" ]]; then
    alias sudo='echo "Dont use sudo in VSCode!!!"; false'
fi
