#!/bin/bash
#
# Usage: progress.sh <current_value> <max_value> [max_units]
# 
# Render a progress bar comprised of dash ("—") characters, based
# on the fraction of `max_value` and `current_value`.
# 
# Positional arguments
# * current_value - The current value of the progress bar
# * max_value     - The maximum value of the progress bar
# * max_units     - The maximum length of the progress bar, in characters.
#                   Default: 20.
#

max=$3
if [ -z "$max" ]
then
  max="20"
fi

curr=$(( $max * $1 / $2 ))
rem=$(( max - curr ))

msg=''
for (( i=0; i<$curr && i<$max; i++ ))
do
  msg=$msg'— '
done

for (( i=0; i<$rem; i++ ))
do
  msg=$msg' '
done
echo $msg 
