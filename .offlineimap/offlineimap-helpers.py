import os
import subprocess

def mailpasswd(path):
    args = ["gpg", "--use-agent", "--quiet", "--batch", "-d", os.path.expanduser(path)]
    try:
        return subprocess.check_output(args).strip()
    except subprocess.CalledProcessError:
        return ""




import re

mapping = { 'INBOX':                'INBOX'
          , '[Gmail]/Drafts':       'drafts'
          , '[Gmail]/Sent Mail':    'sent_mail'
          , '[Gmail]/Spam':         'spam'
          , '[Gmail]/Bin':          'trash'
          }

r_mapping = { val: key for key, val in mapping.items() }

def nt_remote(folder):
    try:
        return mapping[folder]
    except:
#        return re.sub(' ', '_', folder).lower()
        return folder

def nt_local(folder):
    try:
        return r_mapping[folder]
    except:
#        return re.sub('_', ' ', folder).capitalize()
        return folder

# folderfilter = exclude(['Label', 'Label', ... ])
def exclude(excludes):
    def inner(folder):
        try:
            excludes.index(folder)
            return False
        except:
            return True

    return inner

def checkExclude(folder):
    if folder in mapping.keys():
        return True

    if folder.startswith('[Gmail]'):
        return False

    return True




prioritized = ["INBOX", "klinkjak"]
# compares x and y, compares according to priority
def cmpMailBoxes(x, y):
    for prefix in prioritized:
        xsw = x.startswith(prefix)
        ysw = y.startswith(prefix)
        if xsw and ysw:
            return cmp(x, y)
        elif xsw:
            return -1
        elif ysw:
            return +1
    return cmp(x, y)
