#!/bin/bash
# The device name from your output
DEVICE="elan0307:00-04f3:3282-touchpad"
# Storage for the state in RAM
STATE_FILE="/dev/shm/touchpad_state"

# Default to "enabled" (1) if the file doesn't exist
[[ ! -f $STATE_FILE ]] && echo "1" > $STATE_FILE

CURRENT_STATE=$(cat $STATE_FILE)

if [ "$CURRENT_STATE" -eq "1" ]; then
    hyprctl keyword "device[$DEVICE]:enabled" false
    echo "0" > $STATE_FILE
    hyprctl notify 1 2000 "rgb(ff4444)" "Touchpad Disabled"
else
    hyprctl keyword "device[$DEVICE]:enabled" true
    echo "1" > $STATE_FILE
    hyprctl notify 1 2000 "rgb(44ff44)" "Touchpad Enabled"
fi
