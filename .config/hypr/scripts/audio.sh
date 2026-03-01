#!/bin/bash

MUTED=$(pactl get-sink-mute @DEFAULT_SINK@ | awk -F' ' '{print $2}')

if [[ $MUTED == "yes" ]]; then
    echo "<span> </span>"
else
    echo "$(pactl get-sink-volume @DEFAULT_SINK@ | awk -F' ' '{print $5}')"
fi
