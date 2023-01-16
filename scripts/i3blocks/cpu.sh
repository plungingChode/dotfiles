#!/bin/bash

cpu_load=$(vmstat 1 2 | tail -1 | awk '{ printf("%3d", 100 - $15)}')

icon=""
exit_code="0"
color="#BBBBBB"

if [ "$cpu_load" -gt "80" ];
then
    exit_code="33"
elif [ "$cpu_load" -gt "60" ];
then
    color="#FFF859"
fi


full_text=" <span face='Font Awesome 5 Free'>$icon</span> ${cpu_load}% "
echo -e "$full_text\n$full_text\n$color" 
exit "$exit_code"
