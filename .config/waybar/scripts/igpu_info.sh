#!/bin/bash

INTERVAL=1

# ---- GPU USAGE (i915 busy time) ----
read rcs bcs vcs vecs <<< $(
  perf stat -a -x, \
    -e i915/rcs0-busy/,i915/bcs0-busy/,i915/vcs0-busy/,i915/vecs0-busy/ \
    sleep $INTERVAL 2>&1 | cut -d, -f1
)

pct() {
  awk -v v="$1" -v t="$INTERVAL" 'BEGIN { printf "%.0f", (v/(t*1000))*100 }'
}

rcs_u=$(pct "$rcs")
bcs_u=$(pct "$bcs")
vcs_u=$(pct "$vcs")
vecs_u=$(pct "$vecs")

GPU_USAGE=$(printf "%s\n" $rcs_u $bcs_u $vcs_u $vecs_u | sort -nr | head -1)

# ---- GPU TEMP (CPU package temp) ----
TEMP_RAW=$(cat /sys/class/hwmon/hwmon7/temp1_input)
GPU_TEMP=$((TEMP_RAW / 1000))

# ---- Waybar JSON output ----
echo "{\"text\":\"󰾆 ${GPU_USAGE}% ${GPU_TEMP}°C\",\"tooltip\":\"Render: ${rcs_u}%\nBlitter: ${bcs_u}%\nVideo: ${vcs_u}%\nVECS: ${vecs_u}%\"}"

