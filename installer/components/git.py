"""
Git configuration component
"""


from installer import utils

DIRS = [".aliases.d"]

GIT_ALIASES = {
    "aliases.d/git": ".aliases.d/git"
}

def install(interactive):
    dirSuccess = utils.mkDirs(DIRS)
    if dirSuccess[0]:
        utils.linkFileDict(GIT_ALIASES, interactive)
    else:
        print("Could not find or create $HOME/.aliases.d. Skipping installation of git aliases.")
