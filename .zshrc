## colors
autoload colors
colors
if [[ "$TERM" =~ ".*256color.*" && -f ~/.dircolors.256colors ]]; then
    eval $(dircolors ~/.dircolors.256colors)
elif [ -f ~/.dircolors ]; then
    eval $(dircolors ~/.dircolors)
fi


## load modules
for config_file (~/.config/zsh/*.zsh) source $config_file
source ~/.config/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


## Compile zcompdump, if modified, to increase startup speed.
if [ "$HOME/.zcompdump" -nt "$HOME/.zcompdump.zwc" -o ! -e "$HOME/.zcompdump.zwc" ]; then
    zcompile "$HOME/.zcompdump"
fi


## if first argument is "eval", evaluate next arguments as shell command and don't exit
# usage: zsh -is eval 'your shell command here'
if [[ $1 == eval ]]; then
    "$@"
    set --
fi


## environment variables
export PACMAN=pacman-color  # all pacman wrappers should run pacman-color instead of pacman
export COLORFGBG=default,default,default    # I think tmux sets this wrong
export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/dbus/user_bus_socket   # temporal fix until systemd sets this automatically (or until this is the default path for dbus)
