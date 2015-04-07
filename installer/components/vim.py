"""
Vimrc component
"""


from installer import utils

VIMRC = {
    "configs/vimrc": ".vimrc"
}

def install(interactive):
    utils.linkFileDict(VIMRC, interactive)
