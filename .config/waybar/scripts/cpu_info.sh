#!/bin/bash

# 1. Get CPU Usage (%)
# We read /proc/stat twice with a small sleep to calculate delta
PREV_TOTAL=0
PREV_IDLE=0
read -r _ user nice system idle iowait irq softirq steal guest guest_nice </proc/stat
PREV_TOTAL=$((user + nice + system + idle + iowait + irq + softirq + steal))
PREV_IDLE=$((idle + iowait))

sleep 0.5

read -r _ user nice system idle iowait irq softirq steal guest guest_nice </proc/stat
TOTAL=$((user + nice + system + idle + iowait + irq + softirq + steal))
IDLE=$((idle + iowait))

DIFF_TOTAL=$((TOTAL - PREV_TOTAL))
DIFF_IDLE=$((IDLE - PREV_IDLE))
USAGE=$((100 * (DIFF_TOTAL - DIFF_IDLE) / DIFF_TOTAL))

# # 2. Get CPU Temp (MSI/Intel standard)
# # Usually thermal_zone2 or hwmon; we'll find the x86_pkg_temp
# TEMP_PATH=$(find /sys/class/thermal/thermal_zone*/ -type d)
# for zone in $TEMP_PATH; do
# 	if [ -f "$zone/type" ] && grep -qE "x86_pkg_temp|package" "$zone/type"; then
# 		TEMP=$(cat "$zone/temp")
# 		TEMP=$((TEMP / 1000))
# 		break
# 	fi
# done
TEMP=$(cat /sys/devices/platform/msi-ec/cpu/realtime_temperature)

# Fallback if no thermal zone found
TEMP=${TEMP:-0}

# 3. Get Clock Speed (GHz)
FREQ=$(grep "cpu MHz" /proc/cpuinfo | head -1 | awk '{print $4/1000}')
FREQ_ROUNDED=$(printf "%.1f" $FREQ)

# 4. Determine Class (Critical if > 80°C)
CLASS="normal"
if [ "$TEMP" -gt 80 ]; then
	CLASS="critical"
fi

# Output JSON
echo "{\"text\": \"$USAGE% $TEMP°C\", \"tooltip\": \"Freq: ${FREQ_ROUNDED}GHz\", \"class\": \"$CLASS\"}"
