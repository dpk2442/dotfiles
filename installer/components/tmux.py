"""
Tmux configuration component
"""


from installer import utils

TMUX_CONF = {
    "configs/tmux.conf": ".tmux.conf"
}

def install(interactive):
    utils.linkFileDict(TMUX_CONF, interactive)
