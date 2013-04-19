## colors
autoload colors
colors
#if [[ "$TERM" =~ ".*256color.*" && -f ~/.dircolors.256colors ]]; then
if [[ "$TERM" != "linux" && -f ~/.dircolors.256colors ]]; then
    eval $(dircolors ~/.dircolors.256colors)
elif [ -f ~/.dircolors ]; then
    eval $(dircolors ~/.dircolors)
fi


## custom functions
fpath=( ~/.config/zsh/functions "${fpath[@]}" )
source ~/.config/zsh/functions/*.zsh


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


