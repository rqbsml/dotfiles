#!/bin/bash
choice=$(nmcli connection show | awk '{if(NR>1)print $1}' | rofi -dmenu -p "Select Network")
nmcli connection up "$choice"
