#!/bin/bash
EFFECTS=(beams binarypath blackhole bubbles burn colorshift decrypt highlight laseretch matrix orbittingvolley pour print rain randomsequence smoke spotlights sweep synthgrid thunderstorm vhstape waves slide)

while true; do
    EFFECT=${EFFECTS[$RANDOM % ${#EFFECTS[@]}]}
    cat ~/.config/swayidle/screensaver.txt | tte --frame-rate 60 "$EFFECT"
    read -rsn1 -t 5 && break
done