# dpk2442's dotfiles

This is a repository for my Bash configuration files.

It also contains some scripts that I find useful.

## Installation

Clone the repository, and run `./tasks install`. This will make the correct symlinks.

## Uninstall

You can run `./tasks uninstall` to remove the appropriate links.

## Developing

You can run `./tasks create_test_symlinks` to set up symlinks for testing, and `./tasks delete_test_symlinks`
to remove them. Running `./tasks test` will drop you into a bash shell with a minimal environment that loads
from the symlinked .bash_profile.