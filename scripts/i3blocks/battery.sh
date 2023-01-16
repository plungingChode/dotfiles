#!/bin/bash

BAT1="/sys/class/power_supply/BAT1/uevent"

full_charge_design=$(sed -n 's/POWER_SUPPLY_CHARGE_FULL_DESIGN=\(.*\)/\1/p' "$BAT1")
last_full_charge=$(sed -n 's/POWER_SUPPLY_CHARGE_FULL=\(.*\)/\1/p' "$BAT1")
current_charge=$(sed -n 's/POWER_SUPPLY_CHARGE_NOW=\(.*\)/\1/p' "$BAT1")
status=$(sed -n 's/POWER_SUPPLY_STATUS=\(.*\)/\1/p' "$BAT1")

current_charge_percent=$(( $current_charge * 100 / $last_full_charge ))
full_charge_percent=$(( $last_full_charge * 100 / $full_charge_design ))
abs_charge_percent=$(( $current_charge_percent * $full_charge_percent / 100 ))

# https://fontawesome.com/icons/bolt-lightning
icon_charging=""
# https://fontawesome.com/icons/battery-full
icon_full=""
# https://fontawesome.com/icons/battery-three-quarters
icon_three_quarters=""
# https://fontawesome.com/icons/battery-half
icon_half=""
#https://fontawesome.com/icons/battery-quarter
icon_quarter=""
#https://fontawesome.com/icons/battery-empty
icon_empty=""

color="#BBBBBB"
exit_code=0
icon="$icon_empty"
if [ "$status" != "Discharging" ];
then
    if [ $current_charge_percent -lt "99" ];
    then
        color="#FFF859" # yellow
    fi
    icon=$icon_charging
elif [ $current_charge_percent -gt "75" ];
then
    icon=$icon_full
elif [ $current_charge_percent -gt "50" ];
then
    icon=$icon_three_quarters
elif [ $current_charge_percent -gt "25" ];
then
    icon=$icon_half
elif [ $current_charge_percent -gt "10" ];
then
    icon=$icon_quarter
fi

if [ "$abs_charge_percent" -le "20" ] && [ "$status" != "Charging" ];
then
    exit_code="33"
fi

icon="<span face='Font Awesome 5 Free'>$icon</span>"
full_text=" $icon ${abs_charge_percent}% "

echo -e "$full_text\n$full_text\n$color"
exit "$exit_code" 
