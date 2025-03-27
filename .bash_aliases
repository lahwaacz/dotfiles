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
alias vim='nvim -p'
alias vimdiff='nvim -d'

alias du='du -h'
alias df='df -h'
alias free='free -h'
alias top='top -cd 01.00'
alias ps='ps aux'
alias mt='findmnt -rnuc -o SOURCE,TARGET,FSTYPE,OPTIONS | sort | column -t'

alias cal='cal -m'
alias dirs='dirs -v'

alias subdl='/usr/bin/subdl -i --lang=eng,cze'

# slurm
if [[ $(command -v sinfo) ]]; then
    alias sinfo='sinfo --long'
    alias squeue='squeue -o"%.15i %.9P %.8j %.8u %.8T %.11M %.11l %.5D %.4C %.7m %.8Q %R"'
    alias sprio='sprio -o"%.15i %9r %.8u %.10Y %.10S %.10A %.10B %.10F %.10J %.10P %.10Q %.11N %.32T"'
    alias sacct='sacct --format="JobID,JobName,Partition,User,End,State,ExitCode,AllocNodes,AllocCPUS,ReqMem"'
    alias sshare='sshare --all'
fi
