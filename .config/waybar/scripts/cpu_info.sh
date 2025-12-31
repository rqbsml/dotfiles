#!/bin/bash

# ---- CPU USAGE (%), using /proc/stat delta ----
read -r _ user nice system idle iowait irq softirq steal _ _ </proc/stat
PREV_TOTAL=$((user + nice + system + idle + iowait + irq + softirq + steal))
PREV_IDLE=$((idle + iowait))

sleep 0.5

read -r _ user nice system idle iowait irq softirq steal _ _ </proc/stat
TOTAL=$((user + nice + system + idle + iowait + irq + softirq + steal))
IDLE=$((idle + iowait))

DIFF_TOTAL=$((TOTAL - PREV_TOTAL))
DIFF_IDLE=$((IDLE - PREV_IDLE))

if [ "$DIFF_TOTAL" -gt 0 ]; then
  USAGE=$((100 * (DIFF_TOTAL - DIFF_IDLE) / DIFF_TOTAL))
else
  USAGE=0
fi

# ---- CPU TEMP (MSI EC) ----
TEMP=$(cat /sys/devices/platform/msi-ec/cpu/realtime_temperature 2>/dev/null)
TEMP=${TEMP:-0}

# ---- CPU FREQUENCY (GHz) ----
FREQ=$(grep -m1 "cpu MHz" /proc/cpuinfo | awk '{printf "%.1f", $4/1000}')

# ---- CLASS (for styling) ----
CLASS="cpu"
[ "$TEMP" -ge 80 ] && CLASS="cpu critical"

CPU_NAME=$(grep -m1 "model name" /proc/cpuinfo | cut -d: -f2 | xargs | sed -E 's/[0-9]+th Gen //; s/\(TM\)//g; s/ Core//g')
TOOLTIP="$CPU_NAME\nUsage: ${USAGE}%\nFreq: ${FREQ} GHz"

# ---- OUTPUT ----
echo "{\"text\": \"${TEMP}°C\", \"percentage\": ${USAGE}, \"tooltip\": \"$TOOLTIP\", \"class\": \"$CLASS\", \"alt\": \"cpu\"}"
