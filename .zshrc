## history and directory stack config
HISTFILE=$XDG_CONFIG_HOME/zsh/history
HISTSIZE=100000
SAVEHIST=100000
DIRSTACKSIZE=100
setopt INC_APPEND_HISTORY   # append command to history file once executed
setopt HIST_IGNORE_ALL_DUPS # Ignore duplicates in history
setopt HIST_IGNORE_SPACE    # Prevent record in history entry if preceding them with at least one space
setopt AUTO_PUSHD           # auto directory pushd that you can get dirs list by cd -[tab]
setopt PUSHD_IGNORE_DUPS    # ignore directory stack dups

## stuff
setopt NOFLOWCONTROL    # Nobody needs flow control anymore. Troublesome feature.
setopt COMPLETE_IN_WORD # allow tab completion in the middle of a word
setopt AUTO_RESUME      # Resume jobs after typing it's name
setopt CHECK_JOBS       # Dont quit console if processes are running
setopt AUTOCD           # autocd into dirs
setopt EXTENDEDGLOB     # use extended globbing
setopt CORRECTALL       # use autocorrection for commands and args
setopt NOBEEP           # avoid "beep"ing
setopt PROMPT_SUBST     # Enables additional prompt extentions
stty stop ""            # disable <ctrl-s> and <ctrl-q>


## colors
autoload colors
colors
if [ -f ~/.dircolors ]; then
    eval `dircolors ~/.dircolors`
fi


## completion
fpath=($XDG_CONFIG_HOME/zsh/completion $fpath) 
autoload -U $XDG_CONFIG_HOME/zsh/completion/*(:t)
autoload -U compinit
compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.cache/zsh
zstyle ':completion:*' accept-exact '*(N)'
setopt completealiases

### If you want zsh's completion to pick up new commands in $path automatically
### comment out the next line and un-comment the following 5 lines
#zstyle ':completion:::::' completer _complete _approximate
_force_rehash() {
  (( CURRENT == 1 )) && rehash
  return 1 # Because we didn't really complete anything
}
zstyle ':completion:::::' completer _force_rehash _complete _approximate

zstyle -e ':completion:*:approximate:*' max-errors 'reply=( $(( ($#PREFIX + $#SUFFIX) / 3 )) )'
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*:manuals.(^1*)' insert-sections true

# colorful listings
zmodload -i zsh/complist
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' special-dirs true

# formatting and messages
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B- %d -%b'
zstyle ':completion:*:corrections' format '%B- %d - (errors: %e)%b'
zstyle ':completion:*:messages' format '%B- %d -%b'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*' group-name ''

# match uppercase from lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

zstyle ':completion:*:cd:*' ignored-patterns '(*/)#lost+found'
zstyle ':completion:*:*:*:users' ignored-patterns \
    bin daemon mail ftp http nobody dbus avahi usbmux sagemath lxdm ntp
zstyle ':completion:*:*:*:hosts' ignored-patterns \
    github.com localhost localhost.localdomain

zstyle ':completion:*:ssh:*' group-order users hosts
zstyle ':completion:*:scp:*' group-order all-files users hosts

# on processes completion complete all user processes
zstyle ':completion:*:processes' command 'ps -au$USER'

# complete words from tmux pane
# http://blog.plenz.com/2012-01/zsh-complete-words-from-tmux-pane.html
_tmux_pane_words() {
    local expl
    local -a w
    if [[ -z "$TMUX_PANE" ]]; then
        _message "not running inside tmux!"
        return 1
    fi
    w=( ${(u)=$(tmux capture-pane \; show-buffer \; delete-buffer)} )
    _wanted values expl 'words from current tmux pane' compadd -a w
}

zle -C tmux-pane-words-prefix   complete-word _generic
zle -C tmux-pane-words-anywhere complete-word _generic
bindkey '^Xt' tmux-pane-words-prefix
bindkey '^X^X' tmux-pane-words-anywhere
zstyle ':completion:tmux-pane-words-(prefix|anywhere):*' completer _tmux_pane_words
zstyle ':completion:tmux-pane-words-(prefix|anywhere):*' ignore-line current
zstyle ':completion:tmux-pane-words-anywhere:*' matcher-list 'b:=* m:{A-Za-z}={a-zA-Z}'

# Compile zcompdump, if modified, to increase startup speed.
if [ "$HOME/.zcompdump" -nt "$HOME/.zcompdump.zwc" -o ! -e "$HOME/.zcompdump.zwc" ]; then
    zcompile "$HOME/.zcompdump"
fi


## prompt setting
function precmd {
    # let's get the current git branch that we are under
    # ripped from /etc/bash_completion.d/git from the git devs
    git_ps1 () {
        if which git &> /dev/null; then
            local g="$(git rev-parse --git-dir 2>/dev/null)"
            if [ -n "$g" ]; then
                local r
                local b
                if [ -d "$g/rebase-apply" ]; then
                    if test -f "$g/rebase-apply/rebasing"; then
                        r="|REBASE"
                    elif test -f "$g/rebase-apply/applying"; then
                        r="|AM"
                    else
                        r="|AM/REBASE"
                    fi
                    b="$(git symbolic-ref HEAD 2>/dev/null)"
                elif [ -f "$g/rebase-merge/interactive" ]; then
                    r="|REBASE-i"
                    b="$(cat "$g/rebase-merge/head-name")"
                elif [ -d "$g/rebase-merge" ]; then
                    r="|REBASE-m"
                    b="$(cat "$g/rebase-merge/head-name")"
                elif [ -f "$g/MERGE_HEAD" ]; then
                    r="|MERGING"
                    b="$(git symbolic-ref HEAD 2>/dev/null)"
                else
                    if [ -f "$g/BISECT_LOG" ]; then
                        r="|BISECTING"
                    fi
                    if ! b="$(git symbolic-ref HEAD 2>/dev/null)"; then
                       if ! b="$(git describe --exact-match HEAD 2>/dev/null)"; then
                          b="$(cut -c1-7 "$g/HEAD")..."
                       fi
                    fi
                fi
                if [ -n "$1" ]; then
                     printf "$1" "${b##refs/heads/}$r"
                else
                     printf "%s" " G:${b##refs/heads/}$r"
                fi
            fi
        else
            printf ""
        fi
    }

    PR_GIT="$(git_ps1)"

    # The following 9 lines of code comes directly from Phil!'s ZSH prompt
    # http://aperiodic.net/phil/prompt/
    local TERMWIDTH
    (( TERMWIDTH = ${COLUMNS} - 1 ))

    local PROMPTSIZE=${#${(%):--- %D{%H:%M %d.%m.%Y}\! }}
    local PWDSIZE=${#${(%):-%~}}

    if [[ "$PROMPTSIZE + $PWDSIZE" -gt $TERMWIDTH ]]; then
        (( PR_PWDLEN = $TERMWIDTH - $PROMPTSIZE ))
    fi

    # now let's change the color of the path if it's not writable
    if [[ -w $PWD ]]; then
        PR_PWDCOLOR="${PR_BOLD_BLUE}"
    else
        PR_PWDCOLOR="${PR_BOLD_YELLOW}"
    fi 

    # set a simple variable to show when in screen
    if [[ -n "${WINDOW}" ]]; then
        PR_SCREEN=" S:${WINDOW}"
    else
        PR_SCREEN=""
    fi

    # check if jobs are executing
    if [[ $(jobs | wc -l) -gt 0 ]]; then
        PR_JOBS=" J:%j"
    else
        PR_JOBS=""
    fi

    # I want to know my battery percentage when running on battery power
    PR_BATTERY=""
    if which acpi &> /dev/null; then
        local BATT_STATE="$(acpi -b)"
        if [[ $BATT_STATE[(w)3] == "Discharging," ]]; then
            local BATT_PERCENT="${BATT_STATE[(w)-3][1,-3]}"
            local BATT_TIME="$BATT_STATE[(w)-2]"
            local BATT_COLOR=${PR_BOLD_BLUE}
            if [[ "${BATT_PERCENT}" -lt 15 ]]; then
                BATT_COLOR=${PR_BOLD_RED}
            elif [[ "${BATT_PERCENT}" -lt 50 ]]; then
                BATT_COLOR=${PR_BOLD_YELLOW}
            fi
            PR_BATTERY="${BATT_COLOR} B:${BATT_PERCENT}%% (${BATT_TIME})"
        fi
    fi
}

# If I am using vi keys, I want to know what mode I'm currently using.
# zle-keymap-select is executed every time KEYMAP changes.
# From http://zshwiki.org/home/examples/zlewidgets
function zle-line-init zle-keymap-select {
    VIMODE="${${KEYMAP/vicmd/ -- NORMAL -- }/(main|viins)/ -- INSERT -- }"
    zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

setprompt () {
    # Need this, so the prompt will work
    setopt prompt_subst

    # let's load colors into our environment, then set them
    autoload colors

    if [[ "$terminfo[colors]" -gt 8 ]]; then
        colors
    fi

    # The variables are wrapped in %{%}. This should be the case for every
    # variable that does not contain space.
    for COLOR in RED GREEN YELLOW BLUE WHITE BLACK; do
        eval PR_$COLOR='%{$fg_no_bold[${(L)COLOR}]%}'
        eval PR_BOLD_$COLOR='%{$fg_bold[${(L)COLOR}]%}'
    done

    # Finally, let's set the prompt
    PROMPT='${PR_BOLD_RED}<${PR_RED}<${PR_BOLD_BLACK}<${PR_BOLD_WHITE} \
%D{%H:%M %d.%m.%Y}${PR_RED}!${PR_PWDCOLOR}%${PR_PWDLEN}<...<%~%<< \

${PR_BOLD_RED}<${PR_RED}<${PR_BOLD_BLACK}<${PR_BOLD_WHITE} \
%n@%m${PR_RED}!${PR_BOLD_WHITE}%h${PR_BOLD_RED}\
%(?.. E:%?)${PR_BOLD_BLUE}${PR_SCREEN}${PR_JOBS}${PR_GIT}${PR_BATTERY}\
${PR_BOLD_WHITE}${VIMODE}\

${PR_BOLD_BLACK}>${PR_GREEN}>${PR_BOLD_GREEN}>\
%{${reset_color}%} '

    # Of course we need a matching continuation prompt
    PROMPT2='\
${PR_BOLD_BLACK}>${PR_GREEN}>${PR_BOLD_GREEN}>\
${PR_BOLD_WHITE} %_ ${PR_BOLD_BLACK}>${PR_GREEN}>\
${PR_BOLD_GREEN}>%{${reset_color}%} '
}
setprompt

## key bindings (vim mode)
bindkey -v
bindkey "\e[1~" beginning-of-line # Home
bindkey "\e[2~" quoted-insert # Ins
bindkey "\e[3~" delete-char # Del
bindkey "\e[4~" end-of-line # End
bindkey "\e[5~" beginning-of-history # PageUp
bindkey "\e[6~" end-of-history # PageDown
bindkey "\e[5C" forward-word
bindkey "\e[5D" backward-word
bindkey "\e\e[C" forward-word
bindkey "\e\e[D" backward-word
bindkey "\e[Z" reverse-menu-complete # Shift+Tab
bindkey "^?" backward-delete-char # Backspace
bindkey "^D" delete-char-or-list # Delete

bindkey "^[[A" history-search-backward # Up Arrow
bindkey "^[[B" history-search-forward # Down Arrow

bindkey '^i' expand-or-complete-prefix # Attempt shell expansion on the current word up to cursor. If that fails, attempt completion.
bindkey '^R' history-incremental-search-backward # Search backward incrementally for a specified string.


## source some aliases
if [ -f $XDG_CONFIG_HOME/zsh/aliases ]; then
    . $XDG_CONFIG_HOME/zsh/aliases
fi


## other
export EDITOR=vim   # required by yaourt
export COLORFGBG=default,default,default    # I think tmux sets this wrong


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
export TMOUT=300
function TRAPALRM() { 
    if [[ $(tty) != *pts* ]]; then
        vlock
    fi
}


## userul funcions
# h -- grep history
h() {
    fc -l 0 -1 | sed -n "/$1/s/^ */!/p" | tail -n 30
}
alias h=' h'


## fortune message
#if [[ $(setopt | grep login) == "login" ]]; then
#    fortune ferengi_rules_of_acquisition
#    echo
#fi


## if first argument is "eval", evaluate next arguments as shell command and don't exit
# usage: zsh -is eval 'your shell command here'
if [[ $1 == eval ]]
then
    "$@"
set --
fi
