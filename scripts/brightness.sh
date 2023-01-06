#!/bin/bash
#
# Usage: brightness.sh <up|down>
#
# Set display brightness using "brightnessctl" and display an indicator
# based on the current value. 
#
# Requires ~/scripts/progress.sh
#
# Positional arguments
#    * up   - Increase brightness by 5%.
#    * down - Decrease brightness by 5%.
#

# Current brightness
brightness=$(brightnessctl g)

if [ $1 = "down" -a $brightness -gt 6000 ]; then
    brightnessctl -q -d intel_backlight s 5%-
elif [ $1 = "up" ]; then
    brightnessctl -q -d intel_backlight s 5%+
fi

brightness=$(brightnessctl g)
icon="/usr/share/icons/Faba/48x48/notifications/notification-display-brightness.svg"
progress=$(~/scripts/progress.sh $brightness 120000)
dunstify -a 'brightnessChange' -r 69420 -i "$icon" " $progress" 
