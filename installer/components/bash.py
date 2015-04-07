"""
Bash Startup Files Component
"""


from installer import utils

DOTFILES = {
    "bashrc": ".bashrc",
    "bash_profile": ".bash_profile"
}

DIRS = [".bashrc.d"]

BASHRC_D = {
    "bashrc.d/darwin": ".bashrc.d/darwin",
    "bashrc.d/linux": ".bashrc.d/linux"
}

def install(interactive):
        utils.linkFileDict(DOTFILES, interactive)
        dirSuccess = utils.mkDirs(DIRS)
        if dirSuccess[0]:
            utils.linkFileDict(BASHRC_D, interactive)
        else:
            print("Could not create .bashrc.d folder, skipping the installation of those scripts.")
