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

sink="@DEFAULT_SINK@"

if [ $1 = "up" ]; then
    pactl set-sink-mute $sink off
    pactl set-sink-volume $sink +2%
elif [ $1 = "down" ]; then
    pactl set-sink-mute $sink off
    pactl set-sink-volume $sink -2%
elif [ $1 = "m" ]; then
    pactl set-sink-mute $sink toggle
fi

sinks=$(pacmd list-sinks)
active_sink_index=$(echo "$sinks" | awk '/index:/ { print $1 }' | awk '/\*/ { print NR }')
volume=$(echo "$sinks" | awk '/volume: front/ { print $5 }' | sed 's/[^0-9]*//g' | sed "$active_sink_index p;d")
mute=$(echo "$sinks" | awk '/muted/ { print $2 }')
icon="/usr/share/icons/Faba/48x48/notifications/"

if [ "$volume" -gt 150 ]; then
    volume=150
    pactl set-sink-volume $sink 150%
fi 
if [[ "$mute" =~ "yes" ]]; then
    icon=$icon"notification-audio-volume-off.svg"
    volume=0
else
    icon=$icon"notification-audio-volume-medium.svg"
fi

progress=$(~/scripts/progress.sh $volume 150)
dunstify -a 'volumeChange' -r 69420 -i "$icon" " $progress" 
