#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

set -e
set -x

export TURBOVNC_VERSION=2.2.5
export VIRTUALGL_VERSION=2.6.4
export LIBJPEG_VERSION=2.0.5
export WEBSOCKIFY_VERSION=0.9.0
export NOVNC_VERSION=1.2.0

cd /tmp && \
    curl -fsSL -O https://svwh.dl.sourceforge.net/project/turbovnc/${TURBOVNC_VERSION}/turbovnc_${TURBOVNC_VERSION}_amd64.deb \
        -O https://svwh.dl.sourceforge.net/project/libjpeg-turbo/${LIBJPEG_VERSION}/libjpeg-turbo-official_${LIBJPEG_VERSION}_amd64.deb \
        -O https://svwh.dl.sourceforge.net/project/virtualgl/${VIRTUALGL_VERSION}/virtualgl_${VIRTUALGL_VERSION}_amd64.deb \
        -O https://svwh.dl.sourceforge.net/project/virtualgl/${VIRTUALGL_VERSION}/virtualgl32_${VIRTUALGL_VERSION}_amd64.deb && \
    sudo dpkg -i *.deb && \
    rm -f /tmp/*.deb && \
    sed -i 's/$host:/unix:/g' /opt/TurboVNC/bin/vncserver

sudo apt update && sudo apt install -y \
    supervisor \
    xfce4 \
    thunar \
    terminator

#https://github.com/edowson/raptor-talos-ii-power9-technote/blob/master/ubuntu/ubuntu-18.04-configure-virtualgl-turbovnc-gdm3.md
sudo init 3
sudo rmmod nvidia_drm
sudo rmmod nvidia_modeset
sudo rmmod nvidia
# https://cdn.rawgit.com/VirtualGL/virtualgl/2.6.4/doc/index.html#hd006
sudo /opt/VirtualGL/bin/vglserver_config -config +s +f +t
export DISPLAY=:0
sudo /usr/bin/vglgenkey
xauth merge /etc/opt/VirtualGL/vgl_xauth_key
sudo cp /etc/xdg/xfce4/panel/default.xml /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml

echo '#!/bin/bash\n\
xrdb $HOME/.Xresources\n\
startxfce4 &' > $HOME/.vnc/xstartup

echo '[program:turbovnc]
environment=DISPLAY=":0",HOME="/home/ntsoi",USER="ntsoi"
command=/opt/TurboVNC/bin/vncserver :1 -vgl
stderr_logfile = /var/log/supervisord/turbovnc-stderr.log
stdout_logfile = /var/log/supervisord/turbovnc-stdout.log
' | sudo tee /etc/supervisor/conf.d/supervisord.conf

echo suprPass| vncpasswd -f > ~/.vnc/passwd

sudo mkdir /var/log/supervisord/
sudo systemctl enable supervisor

echo PATH=${PATH}:/opt/VirtualGL/bin:/opt/TurboVNC/bin >> ~/.bash_profile

curl -fsSL https://github.com/novnc/noVNC/archive/v${NOVNC_VERSION}.tar.gz | sudo tar -xzf - -C /opt && \
    curl -fsSL https://github.com/novnc/websockify/archive/v${WEBSOCKIFY_VERSION}.tar.gz | sudo tar -xzf - -C /opt && \
    sudo mv /opt/noVNC-${NOVNC_VERSION} /opt/noVNC && \
    sudo mv /opt/websockify-${WEBSOCKIFY_VERSION} /opt/websockify && \
    sudo ln -s /opt/noVNC/vnc_lite.html /opt/noVNC/index.html && \
    cd /opt/websockify && sudo make && sudo mkdir -p lib && sudo mv rebind.so lib/

sudo $DIR/../../ros/bootstrap.sh melodic
sudo $DIR/../../ros/packages.sh melodic
sudo $DIR/../../../scripts/checkout.sh

sudo chown -R $USER:$USER .ros
