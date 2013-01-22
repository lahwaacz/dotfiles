alias grep='nocorrect grep --color=auto'
alias fgrep='nocorrect fgrep --color=auto'
alias egrep='nocorrect egrep --color=auto'

alias ls='ls --color=auto -F'
alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'

# no autocorrection
#alias sudo='sudo '

alias yaourt='nocorrect yaourt'
alias mv='nocorrect mv -i'
alias cp='nocorrect cp -i --preserve=all'
alias pycp='nocorrect pycp -gap'
alias pymv='nocorrect pymv -gap'
alias mkdir='nocorrect mkdir'

alias rm='rm -i'

alias vi='vim'
alias vim='nocorrect vim'

alias du='du -h'
alias df='df -h'
alias free='free -m'
alias top='top -d 01.00'
alias ps='ps aux'
alias mt='findmnt -rnuc -o SOURCE,TARGET,FSTYPE,OPTIONS | sort | column -t'

alias rsp='ssh root@10.0.0.1 -t /root/tmux-startup.sh'
alias pacman='pacman-color'

alias youtube-dl='youtube-dl -c -o "%(title)s.%(ext)s"'
alias wgetr='wget --random-wait -r -k -p -e robots=off -U mozilla -t 3 -l 1'
alias g++='g++ -Wall'
alias make='make -j2'

alias powerdown='sudo powerdown'
alias powerdown-auto='sudo powerdown-auto'
alias powernow='sudo powernow'
alias powerup='sudo powerup'

alias qpdfview='qpdfview --unique'
