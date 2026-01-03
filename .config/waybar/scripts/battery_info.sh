#!/bin/bash

# Define the battery path (MSI usually uses BAT1 or BAT0)
BAT_PATH=$(find /sys/class/power_supply/ -name "BAT*" | head -n 1)

CAPACITY=$(cat "$BAT_PATH/capacity" 2>/dev/null || echo "0")
STATUS=$(cat "$BAT_PATH/status" 2>/dev/null || echo "Unknown")

# Change icon if charging
if [ "$STATUS" = "Charging" ]; then
	CLASS="charging"
elif [ "$STATUS" = "Full" ] || [ "$STATUS" = "Not charging" ]; then
	STATUS="Not Charging"
	CLASS="plugged"
else
	if [ "$CAPACITY" -le 15 ]; then
		CLASS="critical"
	elif [ "$CAPACITY" -le 30 ]; then
		CLASS="warning"
	else CLASS="default"; fi
fi

# echo "{\"text\": \"$CAPACITY\", \"tooltip\": \"Status: $STATUS\", \"class\": \"$CLASS\", \"alt\": \"$CLASS\"\"} 

echo '{"percentage" : '$CAPACITY',"tooltip" : "Status: '$STATUS'","class" : "'$CLASS'","alt" : "'$CLASS'"}'
