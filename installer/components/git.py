"""
Git configuration component
"""


from installer import utils

GITCONFIG = {
    "configs/gitconfig": ".gitconfig"
}

DIRS = [".aliases.d"]

GIT_ALIASES = {
    "aliases.d/git": ".aliases.d/git"
}

def install(interactive):
    utils.linkFileDict(GITCONFIG, interactive)
    dirSuccess = utils.mkDirs(DIRS)
    if dirSuccess[0]:
        utils.linkFileDict(GIT_ALIASES, interactive)
    else:
        print("Could not find or create $HOME/.aliases.d. Skipping installation of git aliases.")
