#!/bin/bash
#
# Usage: shutdown.sh
#
# Display a dmenu prompt to pick shutdown-related action.
#

rv=$(echo -e "cancel\nexit i3\nshutdown\nreboot" | dmenu -b -fn 'Fira Code-15' -nf '#BBBBBB' -nb '#222222' -sb '#900000' -sf '#EEEEEE' -p 'Select an option')

case "$rv" in
    "shutdown") shutdown -h now ;;
    "exit i3") i3-msg exit ;;
    "reboot") reboot ;;
    "cancel") exit 0 ;;
esac
