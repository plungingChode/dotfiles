#!/usr/bin/env bash

source $I3_SCRIPT_HOME/lib.sh

max=150

function getVolume() {
    defaultSink=$(pactl info | grep "Default Sink" | sed 's/.*: //')
    # `pactl list` always contains the current volume, 7 lines after the 
    # sink name. This line contains the volume in percentage, between other 
    # details, delimited by forward slashes. Remove all of these, and pick
    # out the number.
    volume=$(\
        pactl list sinks \
        | grep "${defaultSink}" -A 7 -m 1 \
        | tail -n 1 \
        | cut -d/ -f2 \
        | sed 's/[ %]//g' \
    )

    echo "${volume}"
}

function showVolumeBar() {
    local volume=$(getVolume)
    local icon="" 
    if (( $volume >= 50 )); then
        local icon="" 
    fi
    showProgressBar "volume" $icon $volume $max
}

volume=$(getVolume)
change=$(exponentialCurveX "${volume}")

case $1 in
    "up")
        if (( $volume >= $max )); then
            pactl set-sink-volume @DEFAULT_SINK@ "${max}%"
        else
            pactl set-sink-volume @DEFAULT_SINK@ "+${change}%"
        fi
        showVolumeBar
        ;;
    "down")
        pactl set-sink-volume @DEFAULT_SINK@ "-${change}%"
        showVolumeBar
        ;;
    "mute")
        pactl set-mute @DEFAULT_SINK@ toggle
        ;;
    *)
        echo "usage: $0 [up|down|mute]"
        exit 1
        ;;
esac

