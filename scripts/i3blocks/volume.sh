#!/bin/bash
SINK="@DEFAULT_SINK@"

# Can also be used as a button to select output device
if [ $BLOCK_BUTTON ];
then
    /bin/bash ~/scripts/select-audio-device.sh
fi

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

sink_id=$( pactl get-default-sink )

# https://fontawesome.com/icons/volume-high
volume_icon=""
# https://fontawesome.com/icons/headphones
headphones_icon=""
# https://fontawesome.com/icons/volume-xmark 
mute_icon=""
mute_icon=""

color="#BBBBBB"

if [[ "$mute" = "yes" ]];
then
    icon="$mute_icon"
    color="#808080" # gray
elif [[ "$sink_id" =~ Jabra ]];
then
    icon="$headphones_icon"
else
    icon="$volume_icon"
fi

icon="<span face='Font Awesome 5 Free'>$icon</span>"
full_text=" $icon ${volume}% "
echo -e "$full_text\n$icon\n$color" 
