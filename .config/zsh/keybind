#!/bin/zsh

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

