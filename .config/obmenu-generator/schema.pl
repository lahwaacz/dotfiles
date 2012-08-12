#!/usr/bin/perl

# SCHEMA supports the following keys: item, cat, begin_cat, end_cat,
#                                     exit, raw, sep, obgenmenu
#
# Posible values for each of this types are:
# For 'item' : [COMMAND, LABEL, ICON] - icon is optional
# For 'sep'  : A string representing the LABEL for the separator or undef for none
# For 'cat'  : Any of the possible categories. 'cat => [CATEGORY, LABEL, ICON]'
# For 'exit' : undef - default "Exit" action
# For 'raw'  : A hardcoded XML line in the Openbox's menu.xml file format
#    Example : {raw => '<menu icon="" id="client-list-combined-menu" />'},

# NOTE:
#    * Keys and values are case sensitive. Keep all keys lowercase.
#    * ICON can be a either a direct path to a icon or a valid icon name
#    * Category names are case insensitive. (ex: X-XFCE and x_xfce are equivalent)

require '/home/lahwaacz/.config/obmenu-generator/config.pl';

our $SCHEMA = [
    #            COMMAND               LABEL                ICON
    {item => ['chromium',           'Web Browser',       'chromium']},
    {item => ['spacefm',            'File Manager',      'spacefm']},
    {item => [$CONFIG->{terminal},  'Terminal',          'urxvt']},
    {item => [$CONFIG->{editor},    'Editor',            'gvim']},
    {item => ['pidgin',             'Instant messaging', 'pidgin']},
    #{item => [$items{run_command}, 'Run command',       'system-run']},

    {sep => 'Applications'},

    #          NAME            LABEL                ICON
    {cat => ['utility',     'Accessories', 'applications-utilities']},
    {cat => ['development', 'Development', 'applications-development']},
    {cat => ['education',   'Education',   'applications-science']},
    {cat => ['game',        'Games',       'applications-games']},
    {cat => ['graphics',    'Graphics',    'applications-graphics']},
    {cat => ['audiovideo',  'Multimedia',  'applications-multimedia']},
    {cat => ['network',     'Network',     'applications-internet']},
    {cat => ['office',      'Office',      'applications-office']},
    {cat => ['science',     'Science',     'applications-science']},

    {sep => undef},
    {cat => ['settings',    'Settings',    'applications-settings']},
    {cat => ['system',      'System',      'applications-system']},

    #{cat => ['qt',          'QT Applications',    'qtlogo']},
    #{cat => ['gtk',         'GTK Applications',   'gnome-applications']},
    #{cat => ['x_xfce',      'XFCE Applications',  'applications-other']},
    #{cat => ['gnome',       'GNOME Applications', 'gnome-applications']},
    #{cat => ['consoleonly', 'CLI Applications',   'applications-utilities']},

    #{submenu => 'Openbox Settings'},
    #{sep     => undef},

    #{item => [$items{lock_command}, 'Lock', 'lock']},
    #{exit => [$items{exit_command}, 'Exit', 'exit']},
];

