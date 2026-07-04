#!/bin/bash
EFFECTS=(matrix rain decrypt beams blackhole burn slide)

while true; do
    EFFECT=${EFFECTS[$RANDOM % ${#EFFECTS[@]}]}
    cat ~/.config/swayidle/screensaver.txt | tte --frame-rate 60 "$EFFECT"
    read -rsn1 -t 5 && break
done