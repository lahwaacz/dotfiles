# vim: ft=sh

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

alias mv='mv -i'
alias cp='cp -i --preserve=all'

alias rm='rm -i'

alias vi='vim'

alias du='du -h'
alias df='df -h'
alias free='free -m'
alias top='top -d 01.00'
alias ps='ps aux'
alias mt='findmnt -rnuc -o SOURCE,TARGET,FSTYPE,OPTIONS | sort | column -t'

alias rsp='ssh root@10.0.0.1 -t /root/tmux-startup.sh'

alias g++='g++ -Wall'
alias make='make -j2'

alias powerdown='sudo powerdown'
alias powernow='sudo powernow'
alias powerup='sudo powerup'

alias qpdfview='qpdfview --unique'
alias cal='cal -m'
alias less='less -j4aRi'
alias dirs='dirs -v'

alias youtube-dl='youtube-dl -c -o "%(title)s.%(ext)s"'
alias quvi-dl='quvi -f best --exec "curl %u > ~/stuff/$(echo %t.%e | sed "s/\//\ /)""'

alias quickbrowse="curl -G -d 'mimetype=text/plain'"

alias poweroff='systemctl poweroff'
alias reboot='systemctl reboot'
alias suspend='systemctl suspend'
alias hibernate='systemctl hibernate'
