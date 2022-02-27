#!/bin/bash


set -e
set -x

export ANYDESK_VERSION=6.1.1-1
export DEBIAN_FRONTEND=noninteractive

apt_wait () {
  while sudo fuser /var/lib/dpkg/lock >/dev/null 2>&1 ; do
    sleep 10
  done
  while sudo fuser /var/lib/apt/lists/lock >/dev/null 2>&1 ; do
    sleep 10
  done
  if [ -f /var/log/unattended-upgrades/unattended-upgrades.log ]; then
    while sudo fuser /var/log/unattended-upgrades/unattended-upgrades.log >/dev/null 2>&1 ; do
      sleep 10
    done
  fi
}

pushd /tmp


sleep 15
apt_wait
sudo apt-get autoremove
sudo apt-get clean
sudo apt-get update
#sudo apt-get upgrade -y
apt_wait
sleep 15

# nvidia grid
sudo apt-get install -y build-essential gcc make linux-headers-$(uname -r) awscli libglvnd-dev pkg-config
cat << EOF | sudo tee --append /etc/modprobe.d/blacklist.conf
blacklist vga16fb
blacklist nouveau
blacklist rivafb
blacklist nvidiafb
blacklist rivatv
EOF
cat << EOF | sudo tee --append /etc/default/grub
GRUB_CMDLINE_LINUX="rdblacklist=nouveau"
EOF
sudo update-grub
# permission of the caller should be granted by packer
aws s3 cp --recursive s3://ec2-linux-nvidia-drivers/latest/ .
chmod +x NVIDIA-Linux-x86_64*.run
sudo /bin/sh ./NVIDIA-Linux-x86_64*.run --silent

# ubuntu desktop
sudo apt-get install dialog apt-utils -y
sudo apt-get install -y 'ubuntu-desktop^'

# fix ami images
sudo apt-get purge -yq ifupdown

# anydesk
sudo apt-get install -yq libgtkglext1
curl -o anydesk.deb https://download.anydesk.com/linux/anydesk_${ANYDESK_VERSION}_amd64.deb
sudo apt install libminizip1
sudo dpkg -i anydesk.deb


# xorg config
curl -o xorg.conf https://gist.githubusercontent.com/nathantsoi/470defd7f823e75a0d7a752d07146260/raw/xorg.conf
#sudo mv /etc/X11/xorg.conf /etc/X11/xorg.conf.backup
sudo mv xorg.conf /etc/X11/xorg.conf
sudo update-initramfs -u

# fix gdm3
#idk if this part is necessary:
#wget https://gist.githubusercontent.com/nathantsoi/b7ac0017f8387d0fb23d52d05e627e6d/raw/custom.conf
#sudo mv /etc/gdm3/custom.conf /etc/gdm3/custom.conf.backup
#sudo mv custom.conf /etc/gdm3/custom.conf
sudo apt install -y ubuntu-gnome-desktop
sudo apt install -y --reinstall gdm3

sudo reboot
