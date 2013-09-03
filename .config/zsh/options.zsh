#!/bin/zsh

## history
HISTFILE=~/.config/zsh/history
HISTSIZE=100000
SAVEHIST=100000

setopt INC_APPEND_HISTORY   # append command to history file once executed
setopt HIST_IGNORE_ALL_DUPS # Ignore duplicates in history
setopt HIST_IGNORE_SPACE    # Prevent record in history entry if preceding them with at least one space

## changing directories
DIRSTACKSIZE=10

setopt AUTOCD               # autocd into dirs
setopt AUTO_PUSHD           # Make cd push the old directory onto the directory stack. You can get dirs list by cd -[tab]
setopt PUSHD_IGNORE_DUPS    # ignore directory stack dups
setopt PUSHD_TO_HOME        # Have pushd with no arguments act like 'pushd $HOME'.

## job control
setopt AUTO_RESUME          # Resume jobs after typing it's name
setopt CHECK_JOBS           # Dont quit console if processes are running

## expansion and globbing
setopt EXTENDED_GLOB        # use extended globbing
setopt NUMERIC_GLOB_SORT    # Sort the filenames numerically rather than lexicographically.

## input/output 
unsetopt FLOW_CONTROL       # Nobody needs flow control anymore. Troublesome feature.
setopt correct              # use autocorrection for commands
setopt no_correctall        # don't correct filenames

## other
unsetopt BEEP               # avoid "beep"ing
setopt PROMPT_SUBST         # Enables additional prompt extentions
