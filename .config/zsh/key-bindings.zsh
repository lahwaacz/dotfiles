#!/bin/zsh

# load keydefinitions using zkbd
autoload zkbd
function zkbd_file() {
    local zkbd_path="${HOME}/.config/zsh/zkbd"
    [[ -f ${zkbd_path}/${TERM}-${VENDOR}-${OSTYPE} ]] && printf '%s' "${zkbd_path}/${TERM}-${VENDOR}-${OSTYPE}" && return 0
    [[ -f ${zkbd_path}/${TERM}-${DISPLAY}          ]] && printf '%s' "${zkbd_path}/${TERM}-${DISPLAY}"          && return 0
    return 1
}

[[ ! -d ~/.zkbd ]] && mkdir ~/.zkbd
keyfile=$(zkbd_file)
ret=$?
if [[ ${ret} -ne 0 ]]; then
    zkbd
    keyfile=$(zkbd_file)
    ret=$?
fi
if [[ ${ret} -eq 0 ]] ; then
    source "${keyfile}"
else
    printf 'Failed to setup keys using zkbd.\n'
fi
unfunction zkbd_file; unset keyfile ret


# key bindings (vim mode)
bindkey -v

# use the vi navigation keys in menu completion
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

bindkey "\e[Z" reverse-menu-complete # Shift+Tab
bindkey '^i' expand-or-complete-prefix # attempt shell expansion/completion on the current word up to cursor

# special keys
[[ -n "${key[Home]}"      ]] && bindkey "${key[Home]}"      beginning-of-line
[[ -n "${key[End]}"       ]] && bindkey "${key[End]}"       end-of-line
[[ -n "${key[PageUp]}"    ]] && bindkey "${key[PageUp]}"    beginning-of-history
[[ -n "${key[PageDown]}"  ]] && bindkey "${key[PageDown]}"  end-of-history
[[ -n "${key[Insert]}"    ]] && bindkey "${key[Insert]}"    quoted-insert
[[ -n "${key[Delete]}"    ]] && bindkey "${key[Delete]}"    delete-char-or-list
[[ -n "${key[Backspace]}" ]] && bindkey "${key[Backspace]}" backward-delete-char
[[ -n "${key[Up]}"        ]] && bindkey "${key[Up]}"        history-search-backward
[[ -n "${key[Down]}"      ]] && bindkey "${key[Down]}"      history-search-forward
[[ -n "${key[Left]}"      ]] && bindkey "${key[Left]}"      backward-char
[[ -n "${key[Right]}"     ]] && bindkey "${key[Right]}"     forward-char
