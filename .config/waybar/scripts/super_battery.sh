#!/bin/bash

BAT_PATH=$(find /sys/devices/platform/msi-ec/super_battery 2>/dev/null)

if [ -z "$BAT_PATH" ]; then
    notify-send "Super Battery: Path is not available"
    exit 1
else
    STATUS=$(cat "$BAT_PATH")
fi


if [ "$STATUS" = "on" ]; then
    NEW="off"
elif [ "$STATUS" = "off" ]; then
    NEW="on"
else
    notify-send "Super Battery: Unknwo state ($STATUS)"
    exit 1
fi


if ! echo "$NEW" > "$BAT_PATH"; then
    notify-send "Failed to change Super Battery (need sudo)"
    exit 1
fi


notify-send "Super Battery is $NEW"
echo "success"
