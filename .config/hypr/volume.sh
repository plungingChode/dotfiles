#!/usr/bin/env bash

source $HYPRLAND_CONFIG_DIR/lib.sh

max=150

function showVolumeBar() {
    local volume=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | cut -d' ' -f2)
    local volume=$(bc <<< "scale=0; ${volume}*100/1")
    local icon="" 
    if (( $volume >= 50 )); then
        local icon="" 
    fi
    showProgressBar "volume" $icon $volume $max
}

volume=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | cut -d' ' -f2)
volume=$(bc <<< "scale=0; ${volume}*100/1")
change=$(exponentialCurveX "${volume}")

case $1 in
    "up")
        if (( $volume >= $max )); then
            wpctl set-volume @DEFAULT_AUDIO_SINK@ "${max}%"
        else
            wpctl set-volume @DEFAULT_AUDIO_SINK@ "${change}%+"
        fi
        showVolumeBar
        ;;
    "down")
        wpctl set-volume @DEFAULT_AUDIO_SINK@ "${change}%-"
        showVolumeBar
        ;;
    "mute")
        wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
        ;;
    *)
        echo "usage: $0 [up|down|mute]"
        exit 1
        ;;
esac

