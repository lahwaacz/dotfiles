#!/usr/bin/perl

# desktop_files_paths        : Example: [ "$ENV{'HOME'}/.local/share/applications", '/my/path' ]
# gtk_rc_file                : File where to look for the icon theme (default: ~/.gtkrc-2.0)
# skip_file_name_re          : Ignore desktop files if their filenames match a regex
# skip_app_name_re           : Ignore applications if their names match a regex
# skip_app_command_re        : Ignore applications if their commands match a regex
# skip_file_content_re       : Ignore desktop files if their content match a regex
# subst_command_name_re      : Remove from every command something matched by a regex (/g)
# icon_dirs_first            : Look in this directories before icon theme (when generating icons.db)
# icon_dirs_second           : Look in this directories after the icon theme (when generating icons.db)
# icon_dirs_last             : Look in this directories after all directories (when generating icons.db)

# For regular expressions
#    * is better to use qr/REGEX/ instead of 'REGEX'

# NOTE: Once an icon is found, it will *NOT* be replaced by another.

our $CONFIG = {
  categories_case_sensitive => 0,
  clean_command_name_re     => undef,
  desktop_files_paths       => [
                                 "/usr/share/applications",
                                 "/home/lahwaacz/.local/share/applications",
                               ],
  editor                    => "gvim",
  gtk_rc_filename           => undef,
  icon_dirs_first           => [],
  icon_dirs_last            => ["/usr/share/icons/gnome"],
  icon_dirs_second          => [],
  skip_app_command_re       => undef,
  skip_app_name_re          => undef,
  skip_file_content_re      => undef,
  skip_file_name_re         => undef,
  skip_svg_icons            => 1,
  terminal                  => "urxvt",
  use_only_my_icon_dirs     => 0,
  VERSION                   => 0.53,
}
