#!/usr/bin/env bash

source $HYPRLAND_CONFIG_DIR/lib.sh

max=$(brightnessctl max)

function showBrightnessBar() {
    local brightness=$(brightnessctl get)
    local icon="󰃟 " 
    showProgressBar "brightness" $icon $brightness $max
}

current=$(brightnessctl get)

currentPercent=$(( $current * 100 / $max ))
change=$(exponentialCurveX "${currentPercent}")

case $1 in
    "up")
        brightnessctl set "${change}%+"
        showBrightnessBar
        ;;
    "down")
        if (( $currentPercent <= 1 )); then
            brightnessctl set 1%
        else 
            brightnessctl set "${change}%-"
        fi
        showBrightnessBar
        ;;
    *)
        echo "usage: $0 [up|down]"
        ;;
esac

