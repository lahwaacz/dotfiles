#! /bin/zsh

# Original script can be found here:
# http://askubuntu.com/questions/11634/how-can-i-substitute-colons-when-i-rsync-on-a-usb-key
#
#
# autoload zargs zmv
# zargs -- ~/mail/**/*(/e\''REPLY=/media/usb99/${${REPLY#$HOME/}//:/_}'\') -- mkdir -p --
# zmv -C -Q -o -pu '~/mail/(**/)(*)(.)' '/media/usb99/mail/${1//:/_}${2//:/_}'
#
#
# -  The zargs line is equivalent to mkdir -p ~/mail/**/*(…), except that it won't bomb out if the cumulated
#    length of the directory names are too long. That line creates the target directories as necessary.
#
# -  ~/mail/**/*(/) expands to all the directories under ~/mail (directories only due to the (/) at the end).
#
# -  (/e\''…'\') selects only directories and further executes the code within '…' to transform each file
#    name, which is stored in the REPLY variable.
#
# -  ${${REPLY#$HOME/}//:/_} removes the prefix corresponding with the source directory and changes : into _.
#
# -  zmv -C copies each file matching its first operand (a zsh pattern) to the file name obtained by
#    expandingg its second operand.
#
# -  -o -pu says to pass -pu to the cp utility, so as to preserve permissions and copy only updated files.
#    (We could tell zsh to perform the update check; it would be a little faster but even more cryptic.)
#
# -  (.) selects only regular files. -Q says that this is to be parsed as a glob qualifier and not as a . with
#    parentheses around it indicating a subexpression.
#
# -  $1 and $2 in the replacement text match the parenthesized expressions (**/) and *. (** loses its special)
#    meaning as zero or more subdirectory levels if it's in parentheses, unless the parentheses contain exactly **/.)
#

# Simple (stupid) alternative:
# find -type f -name '*.pat' -print0  | tar -c -f - --null --files-from - | tar -C /path/to/dest -v -x -f - --show-transformed --transform 's/?/_/g'

autoload zargs zmv

fatcp() {
    if [[ ARGC -ne 2 ]] then
        echo "Usage: $0 <srcpat> <dest>"
        return 1
    fi

    local src="$1"
    local dest="$2"

    local replace='<>|;:!?"*\+'
    replace=${(q)replace}

    zmv -C -Q -v -p mkdir -o -p $src/'(**/)(/)' $dest/${src:t}/'${1//[$replace]/_}'
    zmv -C -Q -v -o -pu $src/'(**/)(*)(.)' $dest/${src:t}/'${1//[$replace]/_}${2//[$replace]/_}'
}

#fatcp "$@"

# TODO: globbing fails on files, works only with directories
