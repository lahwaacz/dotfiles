#!/bin/bash

if [ $(id -u) -ne 0 ]; then
    echo "Only root can lock tmux sessions of other users."
    exit 1
fi

users=$(ps aux | grep tmux | awk '{print $1}' | sort -u)
for user in $users; do
    clients=$(su $user -c 'tmux list-clients | egrep "^/dev/tty*" | cut -d" " -f 1')
    for client in $clients; do
        su $user -c "tmux lock-client -t $client"
    done
done
