#!/bin/bash

mem=$(free | sed -n 's/Mem:\(.*\)/\1/p')

bytes_used=$(echo "$mem" | awk '{ print $2 }')
bytes_total=$(echo "$mem" | awk '{ print $1 }')

gbytes_total=$(echo "scale=2; $bytes_total / (1024 * 1024)" | bc | sd "^\." "0.")
gbytes_used=$(echo "scale=2; $bytes_used / (1024 * 1024)" | bc | sd "^\." "0.")

# https://fontawesome.com/icons/memory
icon=""
color="#BBBBBB"

exit_code=0
used_percent=$(( $bytes_used * 100 / $bytes_total ))

if [ "$used_percent" -gt "90" ];
then
    color="#BBBBBB"
    exit_code=33
elif [ "$used_percent" -gt "60" ];
then
    color="#FFF859"
fi

icon="<span face='Font Awesome 5 Free'>$icon</span>"
full_text=" $icon ${gbytes_used} GB "

echo -e "$full_text\n$full_text\n$color"
exit $exit_code

