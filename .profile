umask 0077

# export other directories to PATH
PATH=$PATH:$HOME/bin:$HOME/Scripts

# autostart systemd default session on tty1
if [[ "$(tty)" == '/dev/tty1' ]]; then
    if [[ -z $(pgrep -U $UID systemd) ]]; then
        exec systemd --user
    fi
fi
