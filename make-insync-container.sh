#!/bin/bash

# Set a container name of your choice
CONTAINER=fed-insync

# Create the toolbox container AND initial update
distrobox-create --name $CONTAINER --image fedora:latest
distrobox enter $CONTAINER -- sudo dnf update -y

# Insync Repo 
distrobox enter $CONTAINER -- sudo rpm --import https://d2t3ff60b2tol4.cloudfront.net/repomd.xml.key
distrobox enter $CONTAINER -- sudo sh -c "printf '[insync]\nname=insync repo\nbaseurl=http://yum.insync.io/fedora/\$releasever/\ngpgcheck=1\ngpgkey=https://d2t3ff60b2tol4.cloudfront.net/repomd.xml.key\nenabled=1\nmetadata_expire=120m' > /etc/yum.repos.d/insync.repo"

# Install insync within the container
distrobox enter $CONTAINER -- sudo dnf update -y
distrobox enter $CONTAINER -- sudo dnf install chromium insync -y

# Export Insync start script to host
distrobox enter $CONTAINER -- distrobox-export --app insync  --extra-flags "start" 

# Make insync start at login
cp  ~/.local/share/applications/$CONTAINER-insync.desktop  ~/.config/autostart/

# Start insync
distrobox enter $CONTAINER -- insync start
