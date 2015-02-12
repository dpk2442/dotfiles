# If bash is not running interactively, exit
[[ "$-" == *i* ]] || return

# os detection functions
platform=$(uname)
isDarwin() { [ "$platform" = "Darwin" ]; }
isLinux() { [ "$platform" = "Linux" ]; }


##########################
## Environment includes ##
##########################

# Include all environment parts
if [ -d ~/.env.d ]; then
    for file in ~/.env.d/*; do
        [ -f $file ] && source $file
    done
fi


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
shopt -s globstar 1>/dev/null 2>&1 # Ignore errors. This option may not be present.


#########
## PS1 ##
#########

# shortPWD will shorten the current working directory to an ellipsis followed by the two
# directories directly above it in the folder hierarchy. By default, it uses the unicode
# ellipsis character, but you can specify $SHORT_PWD_NO_UNICODE=1 to change that to
# three ascii dots.

ellipsis='\xe2\x80\xa6'
[ -n "$SHORT_PWD_NO_UNICODE" ] && ellipsis='...'
shortPWD() {
    newPWD=${PWD/$HOME/\~}
    if [ "$(echo -n $newPWD | wc -c | tr -d " ")" -gt 30 ]; then
       newPWD=$(echo -n $newPWD | awk -F '/' '{print "'$ellipsis'/" $(NF-1) "/" $(NF)}')
    fi
    echo -n $newPWD
}

# __git_ps1 options as documented in git-prompt.sh
# Show * for a dirty repository
export GIT_PS1_SHOWDIRTYSTATE=1
# Show whether or not stashes exist
# export GIT_PS1_SHOWSTASHSTATE=1
# Show whether or not the working directory contains untracked files
# export GIT_PS1_SHOWUNTRACKEDFILES=1
# Show whether you are ahead or behind of the upstream repo
# export GIT_PS1_SHOWUPSTREAM="auto"

git_bash() {
    # Use __git_ps1 if the user has that set up, otherwise use a less sophisticated polyfill
    if type __git_ps1 1>/dev/null 2>&1; then
        __git_ps1 " (%s)"
    else
        if [ "$(git rev-parse --is-inside-work-tree 2> /dev/null)" = "true" ]; then
            branch="$(git symbolic-ref --short HEAD)"
            star=""
            if [ -n "$(git status --porcelain)" ]; then
                    star="*"
            fi
            echo " ($branch $star)";
        fi
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

# Include all executable bashrc parts
if [ -d ~/.bashrc.d ]; then
    for file in ~/.bashrc.d/*; do
        [ -f $file ] && source $file
    done
fi

# Include all alias definitions
if [ -d ~/.aliases.d ]; then
    for file in ~/.aliases.d/*; do
        [ -f $file ] && source $file
    done
fi

unset platform
unset isLinux
unset isDarwin
