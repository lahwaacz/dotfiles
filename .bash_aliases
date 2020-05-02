# vim: ft=sh

# enable color support
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias ip='ip --color=auto'

# some more ls aliases
alias ll='ls -alFh'
alias la='ls -A'
alias l='ls -CF'

alias mv='mv -i'
alias cp='cp -i --preserve=all --reflink=auto'

alias rm='rm -i'

alias vi='vim'
alias vim='vim -p'
alias gvim='gvim -p'

alias du='du -h'
alias df='df -h'
alias dh='df -h -x tmpfs -x devtmpfs'
alias free='free -h'
alias top='top -cd 01.00'
alias ps='ps aux'
alias mt='findmnt -rnuc -o SOURCE,TARGET,FSTYPE,OPTIONS | sort | column -t'

alias cal='cal -m'
alias dirs='dirs -v'

alias youtube-dl='youtube-dl -c -o "%(title)s.%(ext)s"'

alias quickbrowse="curl -G -d 'mimetype=text/plain'"

alias poweroff='systemctl poweroff'
alias reboot='systemctl reboot'
alias suspend='systemctl suspend'
alias hibernate='systemctl hibernate'

alias subdl='/usr/bin/subdl -i --lang=eng,cze'

# re-apply alias from /etc/profile.d/openfoam-6.sh
if [[ "$FOAM_INST_DIR" != "" ]]; then
    alias ofoam="source ${FOAM_INST_DIR}/OpenFOAM-6/etc/bashrc"
fi
