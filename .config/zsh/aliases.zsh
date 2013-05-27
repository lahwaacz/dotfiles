alias grep='nocorrect grep --color=auto'
alias fgrep='nocorrect fgrep --color=auto'
alias egrep='nocorrect egrep --color=auto'

# global aliases (expanded in sudo session etc.)
alias -g ls='ls --color=auto -F'
alias -g ll='ls -lah'
alias -g la='ls -A'
alias -g l='ls -CF'

alias mv='nocorrect mv -i'
alias cp='nocorrect cp -i --preserve=all'
alias pycp='nocorrect pycp -gap'
alias pymv='nocorrect pymv -gap'
alias mkdir='nocorrect mkdir'

alias rm='rm -i'

alias vim='nocorrect vim'
alias vi='vim'

alias du='du -h'
alias df='df -h'
alias free='free -m'
alias top='top -d 01.00'
alias ps='ps aux'
alias mt='findmnt -rnuc -o SOURCE,TARGET,FSTYPE,OPTIONS | sort | column -t'

alias rsp='ssh root@10.0.0.1 -t /root/tmux-startup.sh'

alias youtube-dl='youtube-dl -c -o "%(title)s.%(ext)s"'
alias wgetr='wget --random-wait -r -k -p -e robots=off -U mozilla -t 3 -l 1'
alias g++='g++ -Wall'
alias make='make -j2'

alias powerdown='sudo powerdown'
alias powernow='sudo powernow'
alias powerup='sudo powerup'

alias qpdfview='qpdfview --unique'
alias cal='cal -m'
alias less='less -j4aRi'
