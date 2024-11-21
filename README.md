# insync-distrobox
Bash script(s) to create a Fedora container (latest supported container version is Fedora 40) in [distrobox](https://github.com/89luca89/distrobox), install [Insync](https://www.insynchq.com/), and start it automatically on login.

---
# Host Requirements
[distrobox](https://github.com/89luca89/distrobox) must be installed on your host system (only tested with a Podman backend) and is available in nearly all distribution repositories.

## Arch (and derivatives)
```
sudo pacman -S distrobox
```

## Debian/Ubuntu (and derivatives Linux Mint, Zorin, etc.)
```
sudo apt install distrobox
```

## Fedora Silverblue (and derivatives Kinoite, Onyx, etc.)
```
rpm-ostree install distrobox
```
* Restart required after installing `distrobox` and prior to running the script.
* Universal Blue variants Bluefin, Aurora, and Bazzite should already have distrobox installed.

## Fedora Workstation
```
sudo dnf install distrobox
```

## openSUSE Tumbleweed/Leap
```
sudo zypper install distrobox
```

---
# Installation
## Download
Download the `make-insync-container.sh` or `make-insync-rpm-container.sh` files manually or by cloning the repo. If using https authentication:
```
git clone https://github.com/ebits21/insync-distrobox.git
```
if using ssh authentication:
```
git clone git@github.com:ebits21/insync-distrobox.git
```

## (Optional) Changing the Container Name
The container will be named `fedora-distrobox` by default. If you would like a different name, edit the `CONTAINER` variable in the script. (*Do not use special symbols or spaces.*)
```
CONTAINER=my-new-insync-container-name
```

## Run Script
There are two options. Navigate to the directory you saved the script in and execute either:
```
sh make-insync-container.sh
```
This script adds the Insync repo manually and then installs Insync. Alternatively run:
```
sh make-insync-rpm-container.sh
```
This version downloads the appropriate .rpm and installs the .rpm

## Sign-in
You should now be able to use Insync as usual!

## App Indicators
If using Gnome shell on the host I recommend using the [AppIndicator and KStatusNotifierItem Support](https://extensions.gnome.org/extension/615/appindicator-support/) extension to see Insync's app indicator.

## WORKAROUND: Autostart Fix
If Insync does not start at boot, edit the `fedora-distrobox*.desktop` file in `/home/USERNAME/.config/autostart` and add quotation marks:
```
/usr/bin/distrobox-enter -n fedora-distrobox -- /bin/sh -l -c "insync start"
```

---
# Credits
Thanks to [aaylnx on the Insync forums](https://forums.insynchq.com/t/insync-as-flatpak-linux/9615/87?u=ebits21) for most of the basis of the script!
