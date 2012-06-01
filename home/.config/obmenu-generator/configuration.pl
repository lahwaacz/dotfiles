#!/usr/bin/perl

# obmenu-generator config file
#
# SCHEMA supports the following keys: item, cat, exit, raw, sep, submenu
#
# Posible values for each of this types are:
# For 'item': [COMMAND, LABEL, ICON] - icon is optional
# For 'sep' : A string representing the LABEL for the separator or undef for none
# For 'cat' : Any of the possible categories. 'cat => [CATEGORY, LABEL, ICON]' - icon is optional
# For 'raw' : A hardcoded XML line in the Openbox's menu.xml file format
#   Example : {raw => '<menu icon="" id="client-list-combined-menu" />'},

# NOTE:
#    * Keys and values are case sensitive. Keep all keys lowercase.
#    * ICON can be a either a direct path to a icon or a valid icon name
#    * Category names are case insensitive. (ex: X-XFCE and x_xfce are equivalent)

# For regular expressions
#    * is better to use qr/REGEX/ instead of 'REGEX'

my %items = (
    terminal          => 'lxterminal',
    editor            => "gvim",
    file_manager      => 'spacefm',
    web_browser       => 'firefox',
    instant_messaging => 'pidgin',
    run_command       => 'gmrun',
    lock_command      => 'lock-X-session.sh',

    # Giving this an undef value don't hides the menuitem
    # but uses the default OpenBox action "Exit"
    exit_command => undef,
);

our $CONFIG = {

    # Example:   [ "$ENV{'HOME'}/.local/share/applications", '/my/path' ]
    desktop_files_paths => ['/usr/share/applications', "$ENV{'HOME'}/.local/share/applications"],

    # File where to look for icon theme (default: ~/.gtkrc-2.0)
    gtk_rc_file => undef,

    # When 'Terminal=true'
    open_in_terminal => "$items{terminal} -e %s",

    # Editor command
    open_in_editor => "$items{editor}",

    # Ignore desktop files if their filenames match a regex
    ignore_file_name_re => undef,

    # Ignore applications if their names match a regex
    ignore_app_name_re => undef,

    # Ignore applications if their commands match a regex
    ignore_app_command_re => undef,

    # Ignore desktop files if their content match a regex
    ignore_file_content_re => undef,

    # Remove from every command something matched by a regex (/g)
    command_rem_re => undef,

    # Look in this directories first (when generating icons.db)
    dirs_first_to_look => [],

    # Look in this directories as a second icon theme (when generating icons.db)
    dirs_middle_to_look => [],

    # Look in this directories, as a backup plan (when generating icons.db)
    dirs_last_to_look => [],
};

our $SCHEMA = [
    #             COMMAND                    LABEL                ICON
    {item => [$items{web_browser},       'Web Browser',       'firefox']},
    {item => [$items{file_manager},      'File Manager',      'spacefm']},
    {item => [$items{terminal},          'Terminal',          'lxterminal']},
    {item => [$items{editor},            'Editor',            'gvim']},
    {item => [$items{instant_messaging}, 'Instant messaging', 'pidgin']},
    #{item => [$items{run_command},       'Run command',       'system-run']},

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
