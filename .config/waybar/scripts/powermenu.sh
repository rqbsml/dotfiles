#!/usr/bin/env bash

# Buttons with Labels (Icon + Newline + Text)
shutdown=""
reboot="󰜉"
sleep="󰤄"
hibernate="󰒲"
lock="󰌾"
logout="󰍃"

options="$shutdown\n$reboot\n$sleep\n$hibernate\n$lock\n$logout"

# Use -format i to make the case statement easier
chosen="$(echo -e "$options" | rofi -dmenu -format i -kb-select-1 "1" -kb-select-2 "2" -kb-select-3 "3" -kb-select-4 "4" -kb-select-5 "5" -kb-select-6 "6" -theme powermenu.rasi)"

case $chosen in
    0) systemctl poweroff ;;
    1) systemctl reboot ;;
    2) systemctl suspend ;;
    3) systemctl hibernate ;;
    4) hyprlock ;;
    5) loginctl terminate-user $USER ;;
esac