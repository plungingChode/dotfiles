#!/bin/bash

lang=$(xkblayout-state print %s | tr [:lower:] [:upper:])

# https://fontawesome.com/icons/keyboard
icon=""
full_text=" <span face='Font Awesome 5 Free'>$icon</span> $lang "
echo -e "$full_text\n$full_text"
