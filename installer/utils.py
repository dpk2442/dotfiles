"""
Component Installation Utilities

Provided constants:
    HOME_DIR        The user's home directory
    DOTFILES_DIR    The path to the dotfiles repository
"""


## Imports
import os.path
import sys

## Constants
HOME_DIR = os.path.expanduser("~")
DOTFILES_DIR = os.path.dirname(os.path.realpath(sys.argv[0]))

## Helpers
def readYn(prompt):
    """
        Prompts the user for a yes or no answer with the given prompt.
        Defaults to yes.
    """
    return (input(prompt + " [Y/n] ").lower() or "y").startswith("y")

def linkFile(target, linkName, interactive):
    """
        Creates a symlink, guiding the user through a series of prompts if in interactive mode.
        args:
            target       The target of the link
            linkName     The name of the link
            interactive  Interactive flag
    """
    if os.path.exists(linkName):
        if os.path.islink(linkName):
            print("\"{}\" is a link, overwriting...".format(linkName))
            os.remove(linkName)
        else:
            if not interactive or readYn("\"{}\" exists. Should I move it?".format(linkName)):
                newPath = "{}.backup".format(linkName)
                if interactive:
                    newPath = input("Where should I move it? [{}] ".format(newPath)) or newPath
                if os.path.exists(newPath):
                    print("\"{}\" already exists.".format(newPath))
                    print("\"{}\" not successfully linked.".format(target))
                    return
                os.rename(linkName, newPath)
            else:
                print("Overwriting \"{}\"...".format(linkName))
                os.remove(linkName)
    os.symlink(target, linkName)

def linkFileDict(fileDict, interactive):
    """
        Creates symlinks from a dictionary.
        args:
            fileDict     The dictionary to create symlinks from. The key corresponds to the target,
                         relative to the dotfiles repository root, and the value corresponds to the
                         link name, relative to the user's home directory.
            interactive  The interactive flag
    """
    for f in fileDict:
        target = buildDotfilesPath(f)
        linkName = buildHomePath(fileDict[f])
        linkFile(target, linkName, interactive)

def mkDir(path):
    """
        Creates a folder, and returns whether it is successful.
        args:
            path  The path of the folder to create
        return  True if there is a directory at path, false if one could not be created
    """
    if os.path.exists(path):
        if os.path.isfile(path):
            print("Could not create directory \"{}\" because a file already exists there.".format(path))
            return False
        return True
    os.mkdir(path)
    return True

def mkDirs(dirList):
    """
        Make directories relative to the user's home directory.
        args:
            dirList  The list of directories to create
        return  An array containing the mkDir return value for each directory
    """
    return [mkDir(buildHomePath(d)) for d in dirList]

def buildHomePath(path):
    """
        Build an absolute path from a path relative to the user's home directory.
        args:
            path  The relative path
        return  The absolute path
    """
    return os.path.join(HOME_DIR, path)

def buildDotfilesPath(path):
    """
        Build an absolute path from a path relative to the dotfiles repository directory.
        args:
            path  The relative path
        return  The absolute path
    """
    return os.path.join(DOTFILES_DIR, path)
