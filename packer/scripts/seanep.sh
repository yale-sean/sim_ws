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

# noVNC configuration
sudo init 3
sudo rmmod nvidia_drm
sudo rmmod nvidia_modeset
sudo rmmod nvidia_uvm
sudo rmmod nvidia
# https://cdn.rawgit.com/VirtualGL/virtualgl/2.6.4/doc/index.html#hd006
sudo /opt/VirtualGL/bin/vglserver_config -config +s +f +t
export DISPLAY=:0
sudo /usr/bin/vglgenkey
xauth merge /etc/opt/VirtualGL/vgl_xauth_key
sudo cp /etc/xdg/xfce4/panel/default.xml /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml
kill %1

# xorg config
curl -o xorg.conf https://gist.githubusercontent.com/nathantsoi/470defd7f823e75a0d7a752d07146260/raw/xorg.conf
sudo mv /etc/X11/xorg.conf /etc/X11/xorg.conf.backup
sudo mv xorg.conf /etc/X11/xorg.conf
sudo update-initramfs -u
sudo reboot

# vnc server on a given display with
echo 'export PORT=20
export DISPLAY=:${PORT}
/opt/websockify/run 59${PORT} --web=/opt/noVNC --wrap-mode=ignore -- /opt/TurboVNC/bin/vncserver $DISPLAY -vgl -securitytypes TLSNone,X509None,None -noxstartup
xfce4-session &'| sudo tee /opt/websockify/xfce > /dev/null
chmod +x /opt/websockify/xfce
