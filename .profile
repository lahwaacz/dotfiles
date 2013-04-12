umask 0077

# autostart systemd default session on tty1
if [[ "$(tty)" == '/dev/tty1' ]]; then
    if [[ -z $(pgrep -U $UID systemd) ]]; then
        exec systemd --user
    fi
fi
