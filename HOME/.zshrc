## history and directory stack config
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
DIRSTACKSIZE=100
setopt HIST_IGNORE_SPACE    # commands with at least one space get ignored
setopt INC_APPEND_HISTORY   # share history between sessions
setopt HIST_IGNORE_ALL_DUPS # ignore history dups
setopt AUTO_PUSHD           # use automated directory stack
setopt PUSHD_IGNORE_DUPS    # ignore directory stack dups


## stuff
setopt AUTOCD       # autocd into dirs
setopt EXTENDEDGLOB # use extended globbing
setopt CORRECTALL   # use autocorrection for commands and args
setopt NOBEEP       # avoid "beep"ing
setopt prompt_subst # Enables additional prompt extentions
stty stop ""        # disable <ctrl-s> and <ctrl-q>


## colors
autoload colors
colors
for COLOR in RED GREEN YELLOW BLUE MAGENTA CYAN BLACK WHITE; do
    eval $COLOR='$fg_no_bold[${(L)COLOR}]'
    eval BOLD_$COLOR='$fg_bold[${(L)COLOR}]'
done
eval RESET='$reset_color'
if [ -f ~/.dircolors ]; then
    eval `dircolors ~/.dircolors`
fi


## autocompletion
autoload -U compinit
compinit
zstyle ':completion:*' menu select # menu driven autocomplete
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.cache/zsh
zstyle ':completion:*' accept-exact '*(N)'
setopt completealiases


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
    if which acpi &> /dev/null; then
        local BATTSTATE="$(acpi -b)"
        if [[ $BATTSTATE[-1] == \% ]]; then
            local BATTPRCNT="${BATTSTATE[(w)-1][1,-2]}"
            local BATTTIME=""
        else
            local BATTPRCNT="${BATTSTATE[(w)-3][1,-3]}"
            local BATTTIME=" ($BATTSTATE[(w)-2])"
        fi
        PR_BATTERY=" B:${BATTPRCNT}%%${BATTTIME}"
        if [[ "${BATTPRCNT}" -lt 15 ]]; then
            PR_BATTERY="${PR_BOLD_RED}${PR_BATTERY}"
        elif [[ "${BATTPRCNT}" -lt 50 ]]; then
            PR_BATTERY="${PR_BOLD_YELLOW}${PR_BATTERY}"
        elif [[ "${BATTPRCNT}" -lt 100 ]]; then
            PR_BATTERY="${PR_BATTERY}"
        else
            PR_BATTERY=""
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
bindkey "\e[7~" beginning-of-line
bindkey "\e[8~" end-of-line
bindkey "\e[5~" beginning-of-history
bindkey "\e[6~" end-of-history
bindkey "\e[3~" delete-char
bindkey "\e[2~" quoted-insert
bindkey "\e[5C" forward-word
bindkey "\eOc" emacs-forward-word
bindkey "\e[5D" backward-word
bindkey "\eOd" emacs-backward-word
bindkey "\ee[C" forward-word
bindkey "\ee[D" backward-word
bindkey "\^H" backward-delete-word

# completion in the middle of a line
bindkey '^i' expand-or-complete-prefix
bindkey '^R' history-incremental-search-backward
bindkey '\e[A' history-beginning-search-backward
bindkey '\e[B' history-beginning-search-forward


## source ~.zsh_aliases
if [ -f ~/.zsh_aliases ]; then
    . ~/.zsh_aliases
fi
