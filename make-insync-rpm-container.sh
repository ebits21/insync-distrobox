#!/bin/bash

CONTAINER=fedora-distrobox
DISTRO=fedora
VERSION=41
INSYNC_RPM=https://cdn.insynchq.com/builds/linux/3.9.4.60020/insync-3.9.4.60020-fc41.x86_64.rpm
# insync download links json https://cdn.insynchq.com/web/webflow/js/linux_download_links.js
# in var = linux_download_links

# Create Distrobox container
distrobox rm $CONTAINER
distrobox create --name $CONTAINER --image $DISTRO:$VERSION

# Enter the container and perform all necessary steps
distrobox enter $CONTAINER -- bash -c "
    sudo dnf install -y chromium
    curl -o insync.rpm $INSYNC_RPM &&
    sudo dnf install -y ./insync.rpm &&
   
   # Export Insync as a host application
   distrobox-export --app insync --extra-flags 'start' &&

   # Start Insync inside the container
   insync start
"

# Ensure Insync starts at login by copying the .desktop file
if ! cp ~/.local/share/applications/$CONTAINER-insync.desktop ~/.config/autostart/; then
    echo "Failed to copy .desktop file to autostart. Exiting."
    exit 1
fi

echo "Insync setup completed."
