#!/bin/bash


set -e
set -x

export ANYDESK_VERSION=6.1.0-1
export DEBIAN_FRONTEND=noninteractive

apt_wait () {
  while sudo fuser /var/lib/dpkg/lock >/dev/null 2>&1 ; do
    sleep 1
  done
  while sudo fuser /var/lib/apt/lists/lock >/dev/null 2>&1 ; do
    sleep 1
  done
  if [ -f /var/log/unattended-upgrades/unattended-upgrades.log ]; then
    while sudo fuser /var/log/unattended-upgrades/unattended-upgrades.log >/dev/null 2>&1 ; do
      sleep 1
    done
  fi
}

pushd /tmp


# desktop
apt_wait
sudo apt-get update
apt_wait
sudo apt-get install -yq 'ubuntu-desktop^'

# fix ami images
sudo apt-get purge -yq ifupdown

# anydesk
sudo apt-get install -yq libgtkglext1
curl -o anydesk.deb https://download.anydesk.com/linux/anydesk_${ANYDESK_VERSION}_amd64.deb
sudo dpkg -i anydesk.deb

# xorg config
curl -o xorg.conf https://gist.githubusercontent.com/nathantsoi/470defd7f823e75a0d7a752d07146260/raw/xorg.conf
#sudo mv /etc/X11/xorg.conf /etc/X11/xorg.conf.backup
sudo mv xorg.conf /etc/X11/xorg.conf
sudo update-initramfs -u
sudo reboot
