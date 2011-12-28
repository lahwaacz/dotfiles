#!/bin/sh

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
                /etc/acpi/actions/power_button.sh
                ;;
            LID)
                /etc/acpi/actions/lid_toggle.sh
                ;;
            VOLUP|VOLDN|MUTE)
                /etc/acpi/actions/osd_volume.sh
                ;;
            SCRNLCK)
                /etc/acpi/actions/lock_screen.sh
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
