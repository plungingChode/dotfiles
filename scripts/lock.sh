#!/bin/sh

# BLANK='#00000000'
# CLEAR='#ffffff22'
# DEFAULT='#ff00ffcc'
# TEXT='#ee00eeee'
# WRONG='#880000bb'
# VERIFYING='#bb00bbbb'
#
# i3lock \
#     --insidever-color=$CLEAR \
#     --ringver-color=$VERIFYING \
#     \
#     --insidewrong-color=$CLEAR \
#     --ringwrong-color=$WRONG \
#     \
#     --inside-color=$BLANK \
#     --ring-color=$DEFAULT \
#     --line-color=$BLANK \
#     --separator-color=$DEFAULT \
#     \
#     --verif-color=$TEXT \
#     --wrong-color=$TEXT \
#     --time-color=$TEXT \
#     --date-color=$TEXT \
#     --layout-color=$TEXT \
#     --keyhl-color=$WRONG \
#     --bshl-color=$WRONG \
#     \
#     --screen 1 \
#     --blur 5 \
#     --clock \
#     --indicator \
#     --time-str="%H:%M:%S" \
#     --date-str="%A, %Y-%m-%d" \
#     --keylayout 1

BAR_COLOR=2e3440
TEXT_COLOR=d8dee9
ERROR_COLOR=bf616a

i3lock \
    --nofork \
    --blur 5 \
    --bar-indicator \
    --bar-pos y+h \
    --bar-direction 1 \
    --bar-max-height 20 \
    --bar-base-width 20 \
    --bar-color $BAR_COLOR \
    --keyhl-color $TEXT_COLOR \
    --bar-periodic-step 20 \
    --bar-step 20 \
    --redraw-thread \
    --time-str="%H:%M:%S" \
    --date-str="%Y. %m. %d, %A" \
    \
    --clock \
    --force-clock \
    --time-pos x+5:y+h-50 \
    --time-color $TEXT_COLOR \
    --date-pos tx:ty+15 \
    --date-color $TEXT_COLOR \
    --date-align 1 \
    --time-align 1 \
    --ringver-color $TEXT_COLOR \
    --ringwrong-color $ERROR_COLOR \
    --status-pos x+5:y+h-16 \
    --verif-align 1 \
    --wrong-align 1 \
    --verif-color ffffffff \
    --wrong-color ffffffff \
    --modif-pos -20:-20
