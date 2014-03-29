import os
import sys
import subprocess

""" Use gpg to decrypt password.
"""
def mailpasswd(path):
    cmd = "gpg --quiet --batch --use-agent --decrypt --output - " + os.path.expanduser(path)
    try:
        return subprocess.check_output(cmd, shell=True).strip()
    except subprocess.CalledProcessError:
        return ""

# get password either from gpg file (when run from shell) or from stdin (when run from imapfilter)
def get_passwd_check_ppid(path):
    # get parent process cmdline
    f = open("/proc/%s/cmdline" % os.getppid(), "r")
    cmdline = f.read()
    f.close()

    # check if run from imapfilter
    if "imapfilter" in cmdline:
        return raw_input()
    else:
        return mailpasswd(path)


# mapping for nametrans
# dictionary of strings {<remote>: <local>, ...} shape, where <remote> is mapped to <local>

mapping_fjfi = {
    'INBOX'                : 'INBOX',
    'Drafts'               : 'drafts',
    'Sent Items'           : 'sent',
    'Deleted Items'        : 'trash',
    'Junk E-Mail'          : 'spam',
}

mapping_gmail = {
    'INBOX'                : 'INBOX',
    '[Gmail]/Drafts'       : 'drafts',
    '[Gmail]/Sent Mail'    : 'sent',
    '[Gmail]/Bin'          : 'trash',
    '[Gmail]/Spam'         : 'spam',
}

mapping_gmx = {
    'INBOX'                : 'INBOX',
    'Drafts'               : 'drafts',
    'Sent'                 : 'sent',
    'Spam'                 : 'spam',
    'Trash'                : 'trash',
    'arch'                 : 'arch',
    'aur-general'          : 'aur-general',
    'arch-general'         : 'arch-general',
    'arch-wiki'            : 'arch-wiki',
}


# values from mapping_* dicts with high priority
prio_queue_fjfi = ['INBOX']
prio_queue_gmail = ['INBOX']
prio_queue_gmx = ['INBOX', 'arch', 'arch-wiki', 'arch-general', 'aur-general']


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


# compare by position in queue (mapping_*.values())
def fd_priority(prio_queue):
    def inner(x, y):
        if x in prio_queue and y in prio_queue:
            return cmp(prio_queue.index(x), prio_queue.index(y))
        elif x in prio_queue:
            return -1
        elif y in prio_queue:
            return 1
        else:
            return 0
    return inner
