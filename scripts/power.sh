#!/bin/bash

selected=$(\
    echo -e "cancel\nexit i3\nhibernate\nshutdown\nreboot" |\
    rofi -show drun -dmenu -theme-str '* {accent-color: @nord11;}'
)

case "$selected" in
    "shutdown") shutdown now ;;
    "exit i3") i3-msg exit ;;
    "hibernate") systemctl hibernate ;;
    "reboot") reboot ;;
    "cancel") exit 0 ;;
esac

