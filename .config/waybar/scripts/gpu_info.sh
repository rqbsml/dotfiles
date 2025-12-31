#!/bin/bash

# Query: Usage, Temp, Name, Mem Used, Mem Total, Graphics Clock, Max Graphics Clock, Power Draw
RAW=$(nvidia-smi --query-gpu=utilization.gpu,temperature.gpu,gpu_name,memory.used,memory.total,clocks.current.graphics,clocks.max.graphics,power.draw --format=csv,noheader,nounits)

# Clean up commas and split into variables
IFS=',' read -r UTIL TEMP NAME MEM_U MEM_T CLOCK CLOCK_MAX PWR <<< "$RAW"

# Handle if GPU is off/sleeping
if [ -z "$UTIL" ]; then
    echo "{\"text\": \"OFF\", \"alt\": \"gpu\", \"class\": \"gpu\"}"
    exit 0
fi

# Trim whitespace from the name
NAME=$(echo "$NAME" | xargs | sed 's/ Laptop GPU//')

# Tooltip: Values only (no labels) as requested
# Format: Name \n MemoryUsed/Total \n CurrentClock/Max \n Power
TOOLTIP="$NAME\nUsage: $UTIL %\nMemory: $MEM_U/$MEM_T MB\nSpeed: $CLOCK/$CLOCK_MAX MHz\nPower: $PWR W"
TEMP=$(cat /sys/devices/platform/msi-ec/gpu/realtime_temperature)
# Output JSON
# text: Temperature only
# percentage: Usage only
echo "{\"text\": \"$TEMP°C\", \"percentage\": $UTIL, \"tooltip\": \"$TOOLTIP\", \"class\": \"gpu\", \"alt\": \"gpu\"}"
