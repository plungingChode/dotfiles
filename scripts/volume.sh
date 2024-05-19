#!/usr/bin/env bash

source $CUSTOM_SCRIPTS_DIR/lib.sh

MAX=150
POLYBAR_MUTED=1
POLYBAR_NOT_MUTED=0

function getVolume() {
    pactl list sinks |\
    grep $(pactl get-default-sink) -m 1 -A 7 |\
    tail -n 1 |\
    cut -d/ -f2 |\
    sed -e 's/[ %]//g'
}

# "yes" or "no"
function isMuted() {
    pactl list sinks |\
    grep $(pactl get-default-sink) -m 1 -A 6 |\
    tail -n 1 |\
    cut -d: -f2 |\
    cut -d' ' -f2
}

function updatePolybarVolume() {
    # [MUTED] shows up after the volume definition, if the sink is muted
    # TODO pactl is different!
    if [ "$(isMuted)" = "yes" ]; then
        updatePolybar "volume" $POLYBAR_MUTED
    else
        updatePolybar "volume" $POLYBAR_NOT_MUTED
    fi
}

function showVolumeBar() {
    local volume=$(getVolume)
    local icon="" 
    if (( $volume >= 50 )); then
        local icon="" 
    fi
    showProgressBar "volume" $icon $volume $MAX
}

volume=$(getVolume)

case $1 in
    "up")
        # TODO check if valid number
        change=$2
        if [ -z $change ]; then
            change=$(exponentialCurveX "${volume}")
        fi
        if (( $volume >= $MAX )); then
            pactl set-sink-volume @DEFAULT_SINK@ "${MAX}%"
        else
            pactl set-sink-volume @DEFAULT_SINK@ "+${change}%"
        fi
        # showVolumeBar
        updatePolybarVolume
        ;;
    "down")
        change=$2
        if [ -z $change ]; then
            change=$(exponentialCurveX "${volume}")
        fi
        pactl set-sink-volume @DEFAULT_SINK@ "-${change}%"
        # showVolumeBar
        updatePolybarVolume
        ;;
    "mute")
        pactl set-sink-mute @DEFAULT_SINK@ toggle
        updatePolybarVolume
        ;;
    "get")
        getVolume
        ;;
    "initialize-polybar")
        updatePolybarVolume
        getVolume
        ;;
    *)
        echo "usage: $0 [get|initialize-polybar|up|down|mute]"
        exit 1
        ;;
esac

