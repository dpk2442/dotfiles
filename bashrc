# If bash is not running interactively, exit
[[ $- == *i* ]] || exit

# os detection functions
platform=$(uname)
isDarwin() { [ "$platform" = "Darwin" ]; }
isLinux() { [ "$platform" = "Linux" ]; }


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

export PS1="\\[\033[0;32m\\]\u@\h:\$(shortPWD)\$(git_bash)\$ \\[\033[0;36m\\]"
trap 'echo -ne "\033[0;0m"' DEBUG


##############################
## Generally useful aliases ##
##############################

# Colorize ls
isLinux && alias ls='ls --color=auto'
isDarwin && alias ls='ls -G'

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