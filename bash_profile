# Include all executable bash_profile parts for login shell specific configuration
if [ -d ~/.bash_profile.d ]; then
    for file in ~/.bash_profile.d/*; do
        [ -f $file ] && source $file
    done
fi

# Include bashrc for general purpose configuration
if [ -f ~/.bashrc ]; then
	source ~/.bashrc
fi
