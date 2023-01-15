#!/bin/bash
SINK="@DEFAULT_SINK@"

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

# https://fontawesome.com/icons/volume-high
volume_icon=""
# https://fontawesome.com/icons/volume-xmark 
mute_icon=""
mute_icon=""

color=""

if [[ "$mute" = "yes" ]];
then
    icon="$mute_icon"
    color="#808080" # gray
else
    icon="$volume_icon"
fi

icon="<span face='Font Awesome 5 Free'>$icon</span>"
full_text=" $icon ${volume}% "
echo -e "$full_text\n$full_text\n$color" 
