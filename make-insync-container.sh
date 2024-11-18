#!/bin/bash

CONTAINER=fed-insync
INSYNC_GPG_KEY=https://d2t3ff60b2tol4.cloudfront.net/repomd.xml.key
DISTRO=fedora
# I can't escape $releasever properly for some reason, so hard coding version.
# fedora 40 is the latest support version
VERSION=40
INSYNC_URL=http://yum.insync.io/$DISTRO/$VERSION/

# Create Distrobox container
distrobox rm $CONTAINER
distrobox create --name $CONTAINER --image $DISTRO:$VERSION

# Enter the container and perform all necessary steps
distrobox enter $CONTAINER -- bash -c "
  sudo dnf update -y &&

  # Import Insync repo GPG key and add Insync repo
  sudo rpm --import $INSYNC_GPG_KEY &&

  # Create an Insync repo file
  sudo tee /etc/yum.repos.d/insync.repo <<-EOF
	[insync]
	name=insync repo
	baseurl=$INSYNC_URL
	gpgcheck=1
	gpgkey=$INSYNC_GPG_KEY
	enabled=1
	metadata_expire=120m
EOF

  # Update again to make sure repositories are refreshed
  sudo dnf update -y &&

  # Install Insync and chromium
  sudo dnf install insync chromium -y &&

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

echo "Insync setup completed successfully!"
