#!/usr/bin/python

import re
import sys
import time
import urllib.request as req
import xml.etree.ElementTree as ET

from collections import defaultdict, deque
from datetime import datetime
from functools import partial
from platform import uname
from subprocess import check_output

import alsaaudio

ENC = sys.getfilesystemencoding()
bar_format = (
    'ESSID: {essid} [{quality}]  '
    'Gmail: {gmail_count}  '
    'Bat: {batt_state} [{batt_perc}]  '
    'Vol: {alsastate}  '
)
GMAIL_REALM = 'New mail feed'
GMAIL_URI = 'https://mail.google.com/mail/feed/atom'

# re's
net = {
    'essid': re.compile(r'ESSID:"(?P<essid>.+)"', re.I),
    'tx': re.compile(r'Tx\-Power=(?P<tx>\d+)', re.I),
    'quality': re.compile(r'Link Quality=(?P<quality>\d+/\d+)', re.I),
    'rate': re.compile(r'Bit Rate=(?P<rate>\d+ [a-zA-Z]+)', re.I),
    'level': re.compile(r'Signal Level=(?P<level>[+-]\d+ [a-zA-Z]+)', re.I),
}

cpu = {
    'vendor': re.compile(r'vendor_id\s+:\s+(?P<vendor>.+)', re.I),
    'model': re.compile(r'model name\s+:\s+(?P<model>.+)', re.I),
    'speed': re.compile(r'cpu MHz\s+: (?P<speed>\d+)', re.I),
}



def cat(fname):
    f = open(fname, "r")
    s = f.read()
    f.close()
    return s.strip()


class Battery:
    """
    Reads battery status.
    The following keys are returned:
        batt_perc : Percentage of energy stored in the battery
        batt_state : Status of the battery (Charging, Discharging, Unknown)
    """
    def __init__(self):
        self.full = int(cat("/sys/class/power_supply/BAT0/energy_full"))
        self.now_path = "/sys/class/power_supply/BAT0/energy_now"
        self.state_path = "/sys/class/power_supply/BAT0/status"

    def get(self):
        state = cat(self.state_path)
        if state == "Charging":
            state = "CH"
        elif state == "Discharging":
            state = "D"
        else:
            state = "U"
        now = cat(self.now_path)
        percent = round(int(now) / self.full * 100)
        return {"batt_perc": percent, "batt_state": state}

class Alsa:
    """
    Reads volume state using ALSA.
    :parameters:
        control : str
            which ALSA control to read
        id : int
            id of the mixer control
        cardindex : int
            which card should be used
    """

    def __init__(self, control="Master", id=0, cardindex=0):
        self.control = control
        self.id = id
        self.cardindex = cardindex

    def get(self):
        self.mixer = alsaaudio.Mixer(self.control, self.id, self.cardindex)
        if self.mixer.getmute()[0]:
            state = "M"
        else:
            state = self.mixer.getvolume()[0]
        self.mixer.close()
        return {"alsastate": state}

def get_wireless_info(interface='wlan0', encoding=None):
    """
    Reads basic info about your wireless interface using iwconfig.
    :parameters:
        interface : str
            WLAN interface (default: wlan0).
        encoding : str
            Your filesystemencoding, to decode the iwconfig output
            (default: None). Filesystemencoding is attached automatically.
    The following keys are returned:
        essid : Your ESSID
        tx : TX-Power
        quality : Link quality
        rate : Bit Rate per second
        level : Signal level
    """
    d = {}
    out = check_output(['iwconfig', interface])
    out = out.decode(encoding or ENC)
    for name, regex in net.items():
        match = regex.search(out)
        if isinstance(match, type(re.match("", ""))):
            d[name] = match.group(name)
        else:
            d[name] = "-"
    return d

def get_cpu_info():
    """
    Reads some basic info from /proc/cpuinfo.
    The following keys are returned:
        vendor : Vendor ID
        model : Model name
        speed : Speed in MHz
    """
    d = {}
    data = cat("/proc/cpuinfo")
    for name, regex in cpu.items():
        match = regex.search(data)
        d[name] = match.group(name)
    return d


def get_gmail_count(user, passwd):
    """
    Counts new mails for your Gmail account. This is done by parsing
    the provided newsfeed. Your mailbox (IMAP, POP) gets not connected
    every time.
    :parameters:
        user : str
            Gmail username (email address).
        passwd : str
            Password for your Gmail account.
    Returned is only one key:
        gmail_count : Number of new (unread) messages.
    """
    gmail = dict(realm=GMAIL_REALM, uri=GMAIL_URI, user=user, passwd=passwd)
    auth_handler = req.HTTPBasicAuthHandler()
    auth_handler.add_password(**gmail)
    opener = req.build_opener(auth_handler)
    with opener.open(gmail['uri']) as response:
        root = ET.fromstring(response.read())
    count = root.find('{http://purl.org/atom/ns#}fullcount').text
    return dict(gmail_count=count)


def get_date_time(date_format='%Y-%m-%d', time_format='%H:%M'):
    """
    Returns actual date and time. You can use this or the builtin function
    provided by spectrwm.
    :parameters:
        date_format : str
            Format string for the date. See Python docs for usable formats
            (default: '%Y-%m-%d').
        time_format : str
            See date_format (default: '%H:%M').
    Returned are two keys:
        date : Date formatted with date_format
        time : Time formatted with time_format
    """
    dt = datetime.now()
    return dict(date=dt.strftime(date_format), time=dt.strftime(time_format))

class Statusbar:
    """
    :parameters:
        format_str : str
            String which will be outputted on every loop.
    """
    def __init__(self, format_str):
        self.format_str = format_str
        self.align = "right"
        self.length = 117

        self.timeout = 1
        self.actions = deque()
        self.sysinfo = uname()._asdict()

    def register(self, func, timeout, mod=0, *args, **kwargs):
        self.actions.append([partial(func, *args, **kwargs), timeout, mod])

    def loop(self):
        """
        Main loop. Loops every `sleep_secs` over the registered functions
        and returns the collected information formatted with `format_str`.

        Some static keys are present in the context (from uname output)::

            system, node, release, version, machine, processor

        Note that some values from uname can be empty. See Python docs
        (platform.uname) for details.

        Kill the loop with CTRL+C (when testing).
        """
        d = defaultdict(lambda: '-', self.sysinfo)
        try:
            i = 0
            while True:
                for func, timeout, mod in self.actions:
                    if i % timeout == mod:
                        try:
                            ret = func()
                            d.update(ret)
                        except Exception as e:
                            sys.stderr.write(str(e) + '\n')
                line = self.format_str.format_map(d).strip()
                spaces = (self.length - len(line)) * " "
                if self.align == "left":
                    line += spaces
                elif self.align == "right":
                    line = spaces + line
                sys.stdout.write(line + '\n')
                sys.stdout.flush()
                i += 1
                if i > 100:
                    i = 0
                time.sleep(self.timeout)
        except KeyboardInterrupt:
            sys.stderr.write('\rShutting down specbar...\n')


if __name__ == '__main__':
    bar = Statusbar(bar_format)
    battery = Battery()
    bar.register(battery.get, 15, 0)
    alsa = Alsa()
    bar.register(alsa.get, 1)
    bar.register(get_wireless_info, 15, 1)
    bar.loop()
