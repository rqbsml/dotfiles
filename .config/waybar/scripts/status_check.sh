SERVICE=$1
ICON=$2

if systemctl is-active --quiet "$SERVICE"; then
    # Output JSON for Waybar
    echo "{\"text\": \"$ICON\", \"tooltip\": \"$SERVICE is running\", \"class\": \"active\"}"
else
    # Output empty JSON so it disappears
    echo "{\"text\": \"\", \"class\": \"inactive\"}"
fi
