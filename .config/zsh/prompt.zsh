#!/bin/zsh

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
