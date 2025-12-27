#!/bin/bash
if systemctl is-active --quiet docker.service; then
    systemctl stop docker.service docker.socket
    notify-send "Docker" "Service Stopped" -i docker
else
    systemctl start docker.socket docker.service
    notify-send "Docker" "Service Started" -i docker
fi
