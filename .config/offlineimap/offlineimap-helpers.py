import os
import subprocess

""" Use gpg to decrypt password.
"""
def mailpasswd(path):
    cmd = "gpg --quiet --batch --use-agent --decrypt --output - " + os.path.expanduser(path)
    try:
        return subprocess.check_output(cmd, shell=True).strip()
    except subprocess.CalledProcessError:
        return ""


# mapping for nametrans
# dictionary of strings {<remote>: <local>, ...} shape, where <remote> is mapped to <local>

mapping_gmail = {
    'INBOX'                : 'INBOX',
    '[Gmail]/Drafts'       : 'drafts',
    '[Gmail]/Sent Mail'    : 'sent',
    '[Gmail]/Bin'          : 'trash',
    '[Gmail]/Spam'         : 'spam',
    'arch'                 : 'arch',
    'aur-general'          : 'aur-general',
}

mapping_fjfi = {
    'INBOX'                : 'INBOX',
    'Drafts'               : 'drafts',
    'Sent Items'           : 'sent',
    'Deleted Items'        : 'trash',
    'Junk E-Mail'          : 'spam',
}


def nt_remote(mapping):
    def inner(folder):
        try:
            return mapping[folder]
        except:
            return folder
    return inner

def nt_local(mapping):
    r_mapping = dict(zip(mapping.values(), mapping.keys()))
    def inner(folder):
        try:
            return r_mapping[folder]
        except:
            return folder
    return inner


# return False if folder not in mapping.keys()
def exclude(mapping):
    def inner(folder):
        if folder in mapping.keys():
            return True
        return False
    return inner
