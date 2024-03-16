#!/usr/bin/env bash

source ./lib.sh

current=$(brightnessctl get)
max=$(brightnessctl max)

currentPercent=$(( $current * 100 / $max ))
change=$(exponentialCurveX "${currentPercent}")

case $1 in
    "up")
        brightnessctl set "${change}%+"
        ;;
    "down")
        if (( $currentPercent <= 1 )); then
            brightnessctl set 1%
        else 
            brightnessctl set "${change}%-"
        fi
        ;;
    *)
        echo "usage: $0 [up|down]"
        ;;
esac

