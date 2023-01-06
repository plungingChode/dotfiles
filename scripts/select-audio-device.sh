#!/bin/bash

# Set the active audio output (sink) in Pulse Audio (using pacmd)

# Collect available audio devices in "<device name> [<device id>]" format,
# with the devices separated by newlines
awkout=$(pacmd list-sinks | awk '{
    # Indexes 
    if ($1 == "index:" || $1 == "*") {
        # Available devices
        if ($1 == "index:") {
            sink_idx = $2;
            active = "";
        }
        # Selected device index has an extra "*" before it
        if ($1 == "*") { 
            sink_idx = $3;
            active = "*";
        }
    }

    # Card names, print until end of line
    if ($1 ~ /alsa.card_name/ || $1 ~ /device.ladspa.name/) {
        device_name = substr($0, index($0, $3));
        gsub(/"/, "", device_name);
        print device_name " [" sink_idx "] " active;
    }
}')

# Result format <device name> "["<device id>"]""
result=$(echo "$awkout" | dmenu -b -fn 'Fira Code-15' -nf '#BBBBBB' -nb '#222222' -sf '#EEEEEE' -p 'Select audio device')
regex="\[([0-9]+)\]"
if [[ $result =~ $regex ]]
then
    pacmd set-default-sink ${BASH_REMATCH[1]}
fi
