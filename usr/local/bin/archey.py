#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Archey [version 0.3.0]
#
# Archey is a simple system information tool written in Python.
#
# Copyright 2010 Melik Manukyan <melik@archlinux.us>
#
# ASCII art by Brett Bohnenkamper <kittykatt@silverirc.com>
# Changes Jerome Launay <jerome@projet-libre.org>
# Fedora support by YeOK <yeok@henpen.org>
#
# Distributed under the terms of the GNU General Public License v3.
# See http://www.gnu.org/licenses/gpl.txt for the full license text.


import os, sys, subprocess, optparse, re, linecache
from subprocess import Popen, PIPE
from optparse import OptionParser
from getpass import getuser
from time import ctime, sleep


# function to generate terminal color codes
def color(mode="normal", fg="", bg=""):
    esc = "\x1b"
    colors = {"black":"0", "red":"1", "green":"2", "yellow":"3", "blue":"4", "magenta":"5", "cyan":"6", "white":"7", "reset":"9"}
    modes = {"normal":"", "bright":"1", "reset":"0", "bold":"1"}
    fgPrefix = "3"
    bgPrefix = "4"
    
    if fg != "":
        fg = fgPrefix + colors[fg]
    if bg != "":
        bg = bgPrefix + colors[bg]
    
    return esc + "[" + ";".join(filter(None, [modes[mode], fg, bg])) + "m"

colorDict = {
    'Arch Linux': [color(mode="reset", fg="blue"), color(mode="bold", fg="blue")],
    'Ubuntu': ['\x1b[0;31m', '\x1b[1;31m', '\x1b[0;33m'],
    'Debian': ['\x1b[0;31m', '\x1b[1;31m'],
    'Mint': ['\x1b[0;32m', '\x1b[1;37m'],
    'Crunchbang': ['\x1b[1;37m'],
    'Fedora': ['\x1b[0;34m', '\x1b[1;37m'],
    'Sensors': ['\x1b[0;31m', '\x1b[0;32m', '\x1b[0;33m']
    }
    
deDict = {
    'gnome-session': 'GNOME',
    'ksmserver': 'KDE',
    'xfce4-session': 'Xfce',
    'lxsession': 'LXDE'
    }

wmDict = {
    'awesome': 'Awesome',
    'beryl': 'Beryl',
    'blackbox': 'Blackbox',
    'compiz': 'Compiz',
    'dwm': 'DWM',
    'enlightenment': 'Enlightenment',
    'fluxbox': 'Fluxbox',
    'fvwm': 'FVWM',
    'i3': 'i3',
    'icewm': 'IceWM',
    'kwin': 'KWin',
    'metacity': 'Metacity',
    'musca': 'Musca',
    'openbox': 'Openbox',
    'pekwm': 'PekWM',
    'ratpoison': 'ratpoison',
    'scrotwm': 'ScrotWM',
    'wmaker': 'Window Maker',
    'wmfs': 'Wmfs',
    'wmii': 'wmii',
    'xfwm4': 'Xfwm',
    'xmonad': 'xmonad'
    }

logosDict = {'Arch Linux': '''{color[1]}
{color[1]}               +               {space}{results[0]}
{color[1]}               #               {space}{results[1]}
{color[1]}              ###              {space}{results[2]}
{color[1]}             #####             {space}{results[3]}
{color[1]}             ######            {space}{results[4]}
{color[1]}            ; #####;           {space}{results[5]}
{color[1]}           +##.#####           {space}{results[6]}
{color[1]}          +##########          {space}{results[7]}
{color[1]}         ######{color[0]}#####{color[1]}##;        {space}{results[8]}
{color[1]}        ###{color[0]}############{color[1]}+       {space}{results[9]}
{color[1]}       #{color[0]}######   #######       {space}{results[10]}
{color[0]}     .######;     ;###;`\".     {space}{results[11]}
{color[0]}    .#######;     ;#####.      {space}{results[12]}
{color[0]}    #########.   .########`    {space}{results[13]}
{color[0]}   ######'           '######   {space}{results[14]}
{color[0]}  ;####                 ####;  {space}{results[15]}
{color[0]}  ##'                     '##  {space}{results[16]} 
{color[0]} #'                         `# {space}{results[17]}
\x1b[0m'''
}

processes = str(subprocess.check_output(('ps', '-u', getuser(), '-o', 'comm',
    '--no-headers')), encoding='utf8').rstrip('\n').split('\n')

#---------------Classes---------------#

class Output:
    results = []
    
    def __init__(self):
        self.distro = self.__detectDistro()
        
    def __detectDistro(self):
        if os.path.exists('/etc/pacman.conf'):
            return 'Arch Linux'
        else:
            sys.exit(1)
            
    def appendClass(self, display):
        key = display.dict["key"]
        if key != "":
            key += ":"
        value = display.dict["value"]
        self.results.append(colorDict[self.distro][1] + key + color("reset") + " " + value)
    
    def appendText(self, text):
        self.results.append(text)
        
    def output(self):
        self.results.extend(['']*(len(logosDict[self.distro])-len(self.results)))
        print(logosDict[self.distro].format(color=colorDict[self.distro], space="  ", results=self.results))
            
class User:
    def __init__(self):
        self.dict = {"key":"User", "value":os.getenv('USER')}

class Hostname:
    def __init__(self):
        hostname = Popen(['uname', '-n'], stdout=PIPE).communicate()[0].decode('Utf-8').rstrip('\n')
        self.dict = {"key":'Hostname', "value":hostname}
            
class Distro:
    def __init__(self):
        if os.path.exists('/etc/pacman.conf'):
            distro =  'Arch Linux'
        self.dict = {"key":'Distro', "value":distro}
            
class Kernel:
    def __init__(self):
        kernel = Popen(['uname', '-r'], stdout=PIPE).communicate()[0].decode('Utf-8').rstrip('\n')
        self.dict = {"key":'Kernel', "value":kernel}
            
class Uptime:        
    def __init__(self):
        fuptime = int(open('/proc/uptime').read().split('.')[0])
        day = int(fuptime / 86400)
        fuptime = fuptime % 86400
        hour = int(fuptime / 3600)
        fuptime = fuptime % 3600
        minute = int(fuptime / 60)
        uptime = ''
        if day == 1:
            uptime += '%d day, ' % day
        if day > 1:
            uptime += '%d days, ' % day
        uptime += '%d:%02d' % (hour, minute)
        self.dict = {"key":'Uptime', "value":uptime}
    
class WindowManager:
    def __init__(self):
        wm = ''
        for key in wmDict.keys():
            if key in processes:
                wm = wmDict[key]
                break
                    
        self.dict = {"key":'Window Manager', "value":wm}
            
class DesktopEnvironment:
    def __init__(self):
        de = ''
        for key in deDict.keys():
            if key in processes:
                de = deDict[key]
                break
                    
        self.dict = {"key":'Desktop Environment', "value":de}
            
class Shell:
    def __init__(self):
        self.dict = {"key":'Shell', "value":os.getenv('SHELL')}
            
class Terminal:
    def __init__(self):
        self.dict = {"key":'Terminal', "value":os.getenv('TERM')}
            
class Packages:
    def __init__(self):
        p1 = Popen(['pacman', '-Q'], stdout=PIPE).communicate()[0].decode("Utf-8")
        packages = str(len(p1.rstrip('\n').split('\n')))
        self.dict = {"key":'Packages', "value":packages}
        
class CPU:
    def __init__(self):
        cpu = Popen(['uname', '-p'], stdout=PIPE).communicate()[0].decode('Utf-8').rstrip('\n')
        self.dict = {"key":'Kernel', "value":cpu}

class RAM:
    def __init__(self):
        raminfo = Popen(['free', '-m'], stdout=PIPE).communicate()[0].decode('Utf-8').split('\n')
        ram = ''.join(filter(re.compile('M').search, raminfo)).split()
        used = int(ram[2]) - int(ram[5]) - int(ram[6])
        usedpercent = int((float(used) / float(ram[1])) * 100)
        if usedpercent <= 50:
            c = color("reset", "green")
        elif usedpercent <= 80:
            c = color("bold", "yellow")
        else:
            c = color("reset", "red")
        ramdisplay = '%s%sM %s/ %sM %s%s' % (c, used, color("reset"), ram[1], c, str(usedpercent)+"%")
        self.dict = {"key":'RAM', "value":ramdisplay}
            
class Disk:
    def __init__(self, mountpoint):
        p1 = Popen(['df', '-Tlh', mountpoint], stdout=PIPE).communicate()[0].decode("Utf-8")
        line = p1.splitlines()[-1]
        used = line.split()[3]
        size = line.split()[2]
        usedpercent = int(line.split()[5][:-1])
        
        if usedpercent <= 50:
            c = color("reset", "green")
        elif usedpercent <= 80:
            c = color("bold", "yellow")
        else:
            c = color("reset", "red")
        disk = "%s  %s  %s%s%s / %s %s%s" % (color("reset"), mountpoint, c, used, color("reset"), size, c, str(usedpercent)+"%")
        self.dict = {"key":"", "value":disk}

classes = {
    'User': User,
    'Hostname': Hostname,
    'Distro': Distro,
    'Kernel': Kernel,
    'Uptime': Uptime,
    'WindowManager': WindowManager,
    'DesktopEnvironment': DesktopEnvironment,
    'Shell': Shell,
    'Terminal': Terminal,
    'Packages': Packages,
    'CPU': CPU,
    'RAM': RAM
}

output = [ 'User', 'Hostname', 'Distro', 'Kernel', 'Uptime', 'WindowManager', 'DesktopEnvironment', 'Shell', 'Terminal', 'Packages', 'CPU', 'RAM']
mountpoints = ["/", "/home", "/media/data"]

out = Output()
for x in output:
    out.appendClass(classes[x]())
out.appendText(color(mode="bold", fg="blue") + "Disk:")
for mountpoint in mountpoints:
    out.appendClass(Disk(mountpoint))
out.output()