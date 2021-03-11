FROM nvidia/opengl:1.0-glvnd-runtime-ubuntu18.04

### VNC SETUP ###

ARG distro=melodic

ARG TURBOVNC_VERSION=2.2.5
ARG VIRTUALGL_VERSION=2.6.4
ARG LIBJPEG_VERSION=2.0.5
ARG WEBSOCKIFY_VERSION=0.9.0
ARG NOVNC_VERSION=1.2.0

ENV NVIDIA_DRIVER_CAPABILITIES all

RUN apt-get update && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        gcc \
        netcat \
        libc6-dev \
        libglu1 \
        libglu1:i386 \
        libsm6 \
        libxv1 \
        libxv1:i386 \
        libxtst6 \
        libxtst6:i386 \
        make \
        python \
        python-setuptools \
        python-numpy \
        mesa-utils \
        xorg \
        x11-xkb-utils \
        xauth \
        xfonts-base \
        xkb-data \
        dbus-x11 \
        xfce4 \
        thunar \
        terminator && \
    rm -rf /var/lib/apt/lists/*

RUN cd /tmp && \
    curl -fsSL -O https://svwh.dl.sourceforge.net/project/turbovnc/${TURBOVNC_VERSION}/turbovnc_${TURBOVNC_VERSION}_amd64.deb \
        -O https://svwh.dl.sourceforge.net/project/libjpeg-turbo/${LIBJPEG_VERSION}/libjpeg-turbo-official_${LIBJPEG_VERSION}_amd64.deb \
        -O https://svwh.dl.sourceforge.net/project/virtualgl/${VIRTUALGL_VERSION}/virtualgl_${VIRTUALGL_VERSION}_amd64.deb \
        -O https://svwh.dl.sourceforge.net/project/virtualgl/${VIRTUALGL_VERSION}/virtualgl32_${VIRTUALGL_VERSION}_amd64.deb && \
    dpkg -i *.deb && \
    rm -f /tmp/*.deb && \
    sed -i 's/$host:/unix:/g' /opt/TurboVNC/bin/vncserver

# https://cdn.rawgit.com/VirtualGL/virtualgl/2.6.4/doc/index.html#hd006
RUN /opt/VirtualGL/bin/vglserver_config -config +s +f +t

ENV PATH ${PATH}:/opt/VirtualGL/bin:/opt/TurboVNC/bin

RUN curl -fsSL https://github.com/novnc/noVNC/archive/v${NOVNC_VERSION}.tar.gz | tar -xzf - -C /opt && \
    curl -fsSL https://github.com/novnc/websockify/archive/v${WEBSOCKIFY_VERSION}.tar.gz | tar -xzf - -C /opt && \
    mv /opt/noVNC-${NOVNC_VERSION} /opt/noVNC && \
    mv /opt/websockify-${WEBSOCKIFY_VERSION} /opt/websockify && \
    ln -s /opt/noVNC/vnc_lite.html /opt/noVNC/index.html && \
    cd /opt/websockify && make && mkdir -p lib && mv rebind.so lib/


RUN echo 'no-remote-connections\n\
no-httpd\n\
no-x11-tcp-connections\n\
no-pam-sessions\n\
permitted-security-types = TLSNone,X509None,None\
' > /etc/turbovncserver-security.conf

EXPOSE 5901
ENV DISPLAY :1
### END VNC SETUP ###



### ROS SETUP ###
RUN apt-get update && apt-get install -y --no-install-recommends \
        tmux \
        tmuxinator && \
    rm -rf /var/lib/apt/lists/*


### supervisord ###
RUN apt-get update && apt-get install -y supervisor && \
    mkdir -p /var/log/supervisord && \
    rm -rf /var/lib/apt/lists/*

COPY docker/ros/bootstrap.sh /tmp/
COPY docker/ros/packages.sh /tmp/

# boostrap ros
RUN /tmp/bootstrap.sh $distro
# ros packages
RUN /tmp/packages.sh $distro

COPY tmux /root/sim_ws/tmux
COPY src /root/sim_ws/src
### END ROS SETUP ###

# game
COPY bin /root/bin

# novnc
COPY docker/novnc/self.pem /
COPY docker/novnc/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY docker/novnc/xorg.conf /etc/X11/xorg.conf

# dotfiles
COPY docker/novnc/dotfiles/* /root/

# Start novnc and ros, wait for the rosbridge on 9090, then launch the game
COPY docker/novnc/scripts /root/scripts
ENTRYPOINT ["/root/scripts/game.sh"]
### END supervisord ###
