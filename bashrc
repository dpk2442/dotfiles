# If bash is not running interactively, exit
[[ $- == *i* ]] || exit

# os detection functions
platform=$(uname)
isDarwin() { [ "$platform" = "Darwin" ]; }
isLinux() { [ "$platform" = "Linux" ]; }


#############
## History ##
#############

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000


###########################
## General bash settings ##
###########################

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar


#########
## PS1 ##
#########

shortPWD() {
    newPWD=${PWD/$HOME/\~}
    if [ "$(echo -n $newPWD | wc -c | tr -d " ")" -gt 30 ]; then
       newPWD=$(echo -n $newPWD | awk -F '/' '{print "\xe2\x80\xa6/" $(NF-1) "/" $(NF)}')
    fi
    echo -n $newPWD
}

git_bash() {
    if [ "$(git rev-parse --is-inside-work-tree 2> /dev/null)" = "true" ]; then
        branch="$(git symbolic-ref --short HEAD)"
        star=""
        if [ -n "$(git status --porcelain)" ]; then
                star="*"
        fi
        echo " ($branch$star)";
    fi
}

export PS1="\\[\033[0;32m\\]\u@\h:\$(shortPWD)\[\033[0;34m\]\$(git_bash)\[\033[0;32m\]\$ \\[\033[0;36m\\]"
trap 'echo -ne "\033[0;0m"' DEBUG


########################
## Path configuration ##
########################

# Personal bin folder
PATH="$PATH:$HOME/bin"

# Current directory
PATH="$PATH:."

export PATH


##############################
## Generally useful aliases ##
##############################

# Colorize ls
isLinux && alias ls='ls --color=auto'
isDarwin && alias ls='ls -G'

# Colorize grep
alias grep='grep --color=auto'

# Awesome long listing format
alias ll='ls -alhF'

# Use rsync to copy files with a progress bar
alias rsynccp='rsync -a --stats --progress'

# pman - view man pages visually
if isLinux; then
    pman() {
        t=$(mktemp)
        man -t "$@" > $t
        xdg-open $t
    }
elif isDarwin; then
    pman() {
        man -t "$@" | open -f -a Preview
    }
fi

# Terminal tab and editor settings
which tabs 1>/dev/null 2>&1 && tabs -4 >/dev/null
export EDITOR=vim

# Copy current working directory to clipboard
alias copypwd="pwd | tr --delete '\n' | pbcopy"

# Use rsync for copying files
alias rsynccp='rsync -a --stats --progress'

# Search for processes
psgrep() {
    ps aux | grep "[${1:0:1}]${1:1}"
}

# Get a list of process ids
pfind() {
    psgrep "$1" | awk '{print $2}';
}

####################
## Other includes ##
####################

# Include all additional executable bashrc parts
if [ -d .bashrc.d ]; then
    for file in .bashrc.d/*; do
        [ -x $file ] && source $file
    done
fi

# Include all executable alias definitions
if [ -d .aliases.d ]; then
    for file in .aliases.d/*; do
        [ -x $file ] && source $file
    done
fi

unset platform
unset isLinux
unset isDarwin
