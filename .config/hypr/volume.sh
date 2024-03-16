#!/usr/bin/env bash

source ./lib.sh

volume=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | cut -d' ' -f2)
volume=$(bc <<< "scale=0; ${volume}*100/1")
change=$(exponentialCurveX "${volume}")
max=150

case $1 in
    "up")
        if (( $volume >= $max )); then
            wpctl set-volume @DEFAULT_AUDIO_SINK@ "${max}%"
        else
            wpctl set-volume @DEFAULT_AUDIO_SINK@ "${change}%+"
        fi
        ;;
    "down")
        wpctl set-volume @DEFAULT_AUDIO_SINK@ "${change}%-"
        ;;
    "mute")
        wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
        ;;
    *)
        echo "usage: $0 [up|down|mute]"
        exit 1
        ;;
esac

