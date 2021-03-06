FROM nvidia/cudagl:10.1-devel-ubuntu18.04
LABEL maintainer "nathan@vertile.com"

# user-specific arguments
ARG uid
ARG gid
ARG workspacename
ARG username
ARG distro=melodic
ENV USERNAME=$username
ENV WORKSPACENAME=$workspacename

# current ROS distro
ENV ROS_DISTRO=$distro

# disable interactive mode for apt commands
ARG DEBIAN_FRONTEND=noninteractive

# set the locale
RUN apt-get update && apt-get install -y --no-install-recommends locales
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# configure ros
ARG ros_master_uri=http://ros-master:11311
ENV ROS_MASTER_URI=$ros_master_uri

ENV NCCL_VERSION 2.4.2

# nvidia setup
# replace with other Ubuntu version if desired
# https://github.com/osrf/rocker/blob/cd1aefff042539a7adc5e32a379f25d59de24b7b/src/rocker/templates/nvidia_snippet.Dockerfile.em
RUN apt-get update && apt-get install -y --no-install-recommends \
    libglvnd0\
    libgl1 \
    libglx0 \
    libegl1 \
    libgles2 \
    && rm -rf /var/lib/apt/lists/*

COPY --from=nvidia/opengl:1.0-glvnd-runtime-ubuntu18.04 /usr/share/glvnd/egl_vendor.d/10_nvidia.json /usr/share/glvnd/egl_vendor.d/10_nvidia.json
ENV NVIDIA_VISIBLE_DEVICES ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics

# utilities
RUN apt-get update && apt-get install -q -y \
    dirmngr \
    apt-utils \
    wget \
    sudo \
    vim \
    xauth \
    iproute2 \
    net-tools \
    gdb \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# opengl
RUN apt-get update && apt-get install -y --no-install-recommends \
        pkg-config \
        libxau-dev \
        libxdmcp-dev \
        libxcb1-dev \
        libxext-dev \
        libx11-dev && \
    rm -rf /var/lib/apt/lists/*

COPY scripts/bootstrap.sh /tmp/
COPY scripts/packages.sh /tmp/

# boostrap ros
RUN /tmp/bootstrap.sh $distro
# ros packages
RUN /tmp/packages.sh $distro

# user setup
ENV UID=$uid
ENV GID=$gid
RUN mkdir -p /home/$username && \
    echo "${USERNAME}:x:${UID}:${GID}:${USERNAME},,,:/home/${USERNAME}:/bin/bash" >> /etc/passwd && \
    echo "${USERNAME}:x:${GID}:" >> /etc/group && \
    echo "${USERNAME} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${USERNAME} && \
    chmod 0440 /etc/sudoers.d/${USERNAME} && \
    chown ${UID}:${GID} -R /home/${USERNAME}

## vnc password / config
RUN mkdir /home/${USERNAME}/.Xauthority && \
    chown -R ${UID}:${GID} /home/${USERNAME}/.Xauthority

USER ${uid}:${gid}
WORKDIR /home/${USERNAME}
ENV HOME=/home/${USERNAME}

# setup ros
RUN printf "source /opt/ros/melodic/setup.bash \n\
FILE=/home/${USERNAME}/$workspacename/devel/setup.bash && test -f \$FILE && source \$FILE || true\n\
export ROS_MASTER_URI=http://\$(hostname):11311 \n\
export ROS_HOSTNAME=\$(hostname) \n\
export ROS_IP=\$(hostname -i) \n\
export PATH=/sbin/:\$PATH \n\
cd /home/${USERNAME}/$workspacename \
" >> /home/${USERNAME}/.bash_profile

RUN printf "\
set -g mouse on \n\
bind e set -g synchronize-panes \n\
bind C-c run 'tmux save-buffer - | reattach-to-user-namespace pbcopy' \n\
bind C-v run 'tmux set-buffer \$(reattach-to-user-namespace pbpaste); tmux paste-buffer' \n\
bind -T copy-mode-vi y send-keys -X copy-pipe 'reattach-to-user-namespace pbcopy' \n\
" >> /home/${USERNAME}/.tmux.conf

ENTRYPOINT ["/bin/bash", "-l", "-c"]
