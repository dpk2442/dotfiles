# dpk2442's dotfiles

This is a repository for my Bash configuration files.

It also contains some scripts that I find useful.

## Installation

Clone the repository, and run `./tasks install`. This will create a few symlinks. First, it will move any old `.bash_profile` or `.bashrc` out of the way, and then create symlinks to those files in the repository. Next it will attempt to create `.bash_profile.d`, `.bashrc.d`, and `.aliases.d`, if they exist in the repository. If any of those directories already exist, the exisiting directories will be used. If they are files, you will be prompted to move them. Once those directories are in place, any files in the repository that live in those folders will be symlinked as well.

## Uninstall

You can run `./tasks uninstall` to remove the symlinks. This will remove the links for `.bash_profile` and `.bashrc`, as well as any symlinks inside of `.bash_profile.d`, `.bashrc.d`, and `.aliases.d`. The folders will not be deleted, in case any custom scripts were added. If any removed link has a file in the same directory with a `.backup` extension, that file will be moved in place of the link. For example, if you have a `.bashrc.backup` in your home folder, uninstalling will rename that file to `.bashrc`.

## Developing

There are three commands that are useful for developing:
* `./tasks create_test_symlinks` - creates needed symlinks for testing
* `./tasks delete_test_symlinks` - removes needed symlinks for testing
* `./tasks test` - starts a bash shell with the root of the repository as the home folder, and a minimal environment