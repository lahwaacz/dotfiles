#!/bin/sh

DBUS=$(ps aux | grep 'dbus-launch' | grep -v root)
if [[ ! -z $DBUS ]];then
    USER=$(echo $DBUS | awk '{print $1}')
    USERHOME=$(getent passwd $USER | cut -d: -f6)
    export XAUTHORITY="$USERHOME/.Xauthority"
    for x in /tmp/.X11-unix/*; do
        DISPLAYNUM=$(echo $x | sed s#/tmp/.X11-unix/X##)
        if [[ -f "$XAUTHORITY" ]]; then
            export DISPLAY=":$DISPLAYNUM"
        fi
    done
else
    USER=lahwaacz
    USERHOME=/home/$USER
    export XAUTHORITY="$USERHOME/.Xauthority"
    export DISPLAY=":0"
fi
export HOME=$USERHOME   # required by oblogout

case "$1" in
    hotkey)
        case "$2" in
            ATK0100:00)
                case "$3" in
                    0000006b)
                        /etc/acpi/actions/toggle_touchpad.sh
                        ;;
                esac
                ;;
        esac
        ;;
    button*)
        case "$2" in
            PBTN)
                oblogout
                ;;
            LID)
                lxlock
                /etc/acpi/actions/lid_toggle.sh
                ;;
            VOLUP|VOLDN|MUTE)
                /etc/acpi/actions/osd_volume.sh
                ;;
            SCRNLCK)
                lxlock
                ;;
            *)
                logger "ATKD handler - undefined action (arguments: $@)"
                ;;
        esac
        ;;
    video*)
        case "$2" in
            BRTUP|BRTDN)
                /etc/acpi/actions/osd_lcd_brightness.sh
                ;;
            *)
                logger "ATKD handler - undefined action (arguments: $@)"
                ;;
        esac
        ;;
esac
