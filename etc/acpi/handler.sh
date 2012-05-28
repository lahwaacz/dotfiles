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
                /etc/acpi/actions/lid_toggle.sh
                ;;
            VOLUP|VOLDN|MUTE)
                /etc/acpi/actions/osd_volume.sh
                ;;
            SCRNLCK)
                /usr/local/bin/lock-tmux-console-clients.sh
                su $USER -c "lock-X-session.sh"
                ;;
            WLAN)
                /etc/acpi/actions/wireless-switch.sh
                if [ -f /var/run/wpa_supplicant_*.pid ]; then
                    rc.d stop net-auto-wireless
                else
                    rc.d start net-auto-wireless
                fi
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
