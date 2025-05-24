#!/bin/bash

if ! upower -e | grep -q BAT; then
    echo "No battery found. Exiting."
    exit 0
fi

while true; do
    battery=$(upower -i "$(upower -e | grep BAT)" | awk '/percentage:/ {gsub(/%/, "", $2); print $2}')
    if [ "$battery" -le 20 ]; then
	notify-send -i battery-low -u critical -t 5000 "Low Battery  " "Battery level is at ${battery}%!"	
        sleep 240
    else
        sleep 120
    fi
done
