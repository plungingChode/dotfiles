#!/bin/sh

current_layout=$(setxkbmap -query | sed -n 's/layout:     \(.*\)/\1/p')

case "$current_layout" in
    "gb") setxkbmap hu ;;
    "hu") setxkbmap gb ;;
esac
