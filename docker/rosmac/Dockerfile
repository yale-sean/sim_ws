#FROM ubuntu:18.04
FROM dorowu/ubuntu-desktop-lxde-vnc:focal
LABEL maintainer "nathan@vertile.com"

# user-specific arguments
ARG uid
ARG gid
ARG workspacename
ARG username
ARG distro=noetic
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

COPY scripts/bootstrap.sh /tmp/
COPY scripts/packages.sh /tmp/

# boostrap ros
RUN /tmp/bootstrap.sh $distro
# ros packages
RUN /tmp/packages.sh $distro

# fix the costmap2d build... idk why this is necessary
RUN sudo ln -sf /usr/include /include

# user setup
ENV UID=$uid
ENV GID=$gid
RUN mkdir -p /home/$username && \
    echo "${USERNAME}:x:${UID}:${GID}:${USERNAME},,,:/home/${USERNAME}:/bin/bash" >> /etc/passwd && \
    echo "${USERNAME}:x:${GID}:" >> /etc/group && \
    echo "${USERNAME} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${USERNAME} && \
    chmod 0440 /etc/sudoers.d/${USERNAME} && \
    chown ${UID}:${GID} -R /home/${USERNAME}

USER ${uid}:${gid}
WORKDIR /home/${USERNAME}
ENV HOME=/home/${USERNAME}

# setup ros
RUN printf "source /opt/ros/${ROS_DISTRO}/setup.bash \n\
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

ENTRYPOINT ["/bin/bash", "-l"]

