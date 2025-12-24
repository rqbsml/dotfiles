#!/usr/bin/env bash

# Rofi config (optional)
ROFI="rofi -dmenu -i -p Wi-Fi"

# Get Wi-Fi status
WIFI_STATE=$(nmcli -t -f WIFI g)

if [[ "$WIFI_STATE" == "disabled" ]]; then
    echo "Enable Wi-Fi" | rofi -dmenu -p "Wi-Fi is off" | grep -q "Enable" && nmcli radio wifi on
    exit 0
fi

# List networks
NETWORKS=$(nmcli -t -f IN-USE,SSID,SECURITY,SIGNAL dev wifi list |
awk -F: '
function bars(sig) {
    if (sig > 80) return "󰤨"
    else if (sig > 60) return "󰤥"
    else if (sig > 40) return "󰤢"
    else if (sig > 20) return "󰤟"
    else return "󰤯"
}
{
    inuse = ($1 == "*") ? "󰸞" : " "
    ssid  = ($2 == "") ? "<hidden>" : $2
    sec   = ($3 == "--") ? "Open" : "🔒"

    # Left side (variable)
    left = sprintf(" %-2s %s", inuse, ssid)

    # Right side (fixed)
    right = sprintf(" %-6s %-2s", sec, bars($4))

    # Pad so right column always aligns
    printf "%-40s%s\n", left, right
}')

CHOSEN=$(echo "$NETWORKS" | $ROFI)

[ -z "$CHOSEN" ] && exit 0

SSID=$(echo "$CHOSEN" | cut -d: -f2)
SECURITY=$(echo "$CHOSEN" | cut -d: -f3)

# Open networks
if [[ "$SECURITY" == "--" ]]; then
    nmcli dev wifi connect "$SSID"
else
    PASS=$(rofi -dmenu -password -p "Password for $SSID")
    [ -z "$PASS" ] && exit 0
    nmcli dev wifi connect "$SSID" password "$PASS"
fi

