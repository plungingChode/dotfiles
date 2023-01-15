#!/bin/bash
#
# Usage: volume.sh <up|down|m>
#
# Modify the volume of the current audio output device and print and indicator
# based on the current status.
#
# Positional arguments
#    * up   - Increase volume by 2% and unmute.
#    * down - Decrease volume by 2% and unmute.
#    * m    - Toggle mute.
#

SINK="@DEFAULT_SINK@"
MAX_VOLUME="150"

case $1 in
    "u" | "up")
        pactl set-sink-mute $SINK off
        pactl set-sink-volume $SINK +2%
        ;;
    "d" | "down")
        pactl set-sink-mute $SINK off
        pactl set-sink-volume $SINK -2%
        ;;
    "m" | "mute")
        pactl set-sink-mute $SINK toggle
        ;;
    *)
        echo "unknown argument $1"
        exit 1
        ;;
esac

volume=$(
    pactl get-sink-volume "$SINK" \
        | sd "%.*" "" \
        | sd ".*? / " "" \
        | head -n 1
)
mute=$(
    pactl get-sink-mute "$SINK" \
        | sd "Mute: " ""
)
icon="/usr/share/icons/Faba/48x48/notifications"

# Cap volume at MAX_VOLUME
if [ "$volume" -gt "$MAX_VOLUME" ]; then
    volume=150
    pactl set-sink-volume "$SINK" "$MAX_VOLUME"%
fi 

if [[ "$mute" =~ "yes" ]]; then
    icon="${icon}/notification-audio-volume-off.svg"
    volume=0
else
    icon="${icon}/notification-audio-volume-medium.svg"
fi

progress=$(~/scripts/progress.sh "$volume" "$MAX_VOLUME")
dunstify -a 'volumeChange' -r 69420 -i "$icon" " $progress" 
