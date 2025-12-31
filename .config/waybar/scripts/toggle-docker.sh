#!/bin/bash

SERVICE="docker"
NAME="Docker"
ICON="dialog-success"

if systemctl is-active --quiet ${SERVICE}.service; then
    # Try stopping Docker
    if systemctl stop ${SERVICE}.service ${SERVICE}.socket; then
        notify-send "${NAME}" "Service Stopped" -i dialog-information
    else
        notify-send "${NAME}" "Failed to stop service! Check permissions." -i dialog-error
    fi
else
    # Try starting Docker
    if systemctl start ${SERVICE}.socket ${SERVICE}.service; then
        notify-send "${NAME}" "Service Started" -i dialog-ok
    else
        notify-send "${NAME}" "Failed to start service! Check permissions." -i dialog-error
    fi
fi

