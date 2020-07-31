FROM nvidia/cudagl:10.1-devel-ubuntu18.04
LABEL maintainer "nathan@vertile.com"

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

#RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F42ED6FBAB17C654
#RUN apt-get update && apt-get install -y --no-install-recommends \
#        cuda-libraries-$CUDA_PKG_VERSION \
#        cuda-nvtx-$CUDA_PKG_VERSION \
#        libnccl2=$NCCL_VERSION-1+cuda10.1 && \
#    apt-mark hold libnccl2 && \
#    rm -rf /var/lib/apt/lists/*

# install packages
RUN apt-get update && apt-get install -q -y \
    dirmngr \
    gnupg2 \
    lsb-release \
    && rm -rf /var/lib/apt/lists/*

# setup keys
RUN apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

# setup sources.list
RUN echo "deb http://packages.ros.org/ros/ubuntu `lsb_release -sc` main" > /etc/apt/sources.list.d/ros-latest.list

# install bootstrap tools
RUN apt-get update && apt-get install --no-install-recommends -y \
    python-catkin-tools \
    python-rosinstall-generator \
    python-rosdep \
    python-rosinstall \
    python-vcstools \
    && rm -rf /var/lib/apt/lists/*

# setup environment
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# bootstrap rosdep
RUN rosdep init \
    && rosdep update

# install ros packages
ENV ROS_DISTRO melodic
RUN apt-get update && apt-get install -y \
    ros-${ROS_DISTRO}-ros-core \
    ros-${ROS_DISTRO}-ros-base \
    && rm -rf /var/lib/apt/lists/*

# robot
RUN apt-get update && apt-get install -y \
    ros-${ROS_DISTRO}-robot \
    && rm -rf /var/lib/apt/lists/*

# desktop full
RUN apt-get update && apt-get install -y \
    ros-${ROS_DISTRO}-desktop \
    ros-${ROS_DISTRO}-desktop-full \
    && rm -rf /var/lib/apt/lists/*

# workspace specific dependencies
RUN apt-get update && apt-get install -y \
    libatlas-base-dev \
    libjpeg-dev \
    libpng-dev \
    libblas-dev \
    libgfortran-4.8-dev \
    libz-dev \
    libpcap-dev \
    libsvm-dev \
    libcanberra-gtk-module \
    pcl-tools \
    python-webcolors \
    python-pygame \
    python-pip \
    python3-pip \
    python3-setuptools \
    python3.7-venv \
    xsltproc \
    && rm -rf /var/lib/apt/lists/*

# pips
RUN pip install virtualenv

# other tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    apt-utils \
    wget \
    sudo \
    vim \
    xauth \
    iproute2 \
    net-tools \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# gdb
RUN apt-get update && apt-get install -y --no-install-recommends \
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

# replace with other Ubuntu version if desired
# https://github.com/osrf/rocker/blob/cd1aefff042539a7adc5e32a379f25d59de24b7b/src/rocker/templates/nvidia_snippet.Dockerfile.em
RUN apt-get update && apt-get install -y --no-install-recommends \
    libglvnd0\
    libgl1 \
    libglx0 \
    libegl1 \
    libgles2 \
    && rm -rf /var/lib/apt/lists/*

# ros packages
RUN apt-get update && apt-get install -y \
    ros-${ROS_DISTRO}-openni2-* \
    ros-${ROS_DISTRO}-usb-cam \
    ros-${ROS_DISTRO}-rosbash \
    ros-${ROS_DISTRO}-tf2-sensor-msgs \
    ros-${ROS_DISTRO}-tf2-tools \
    ros-${ROS_DISTRO}-rosbridge-suite \
    ros-${ROS_DISTRO}-web-video-server \
    ros-${ROS_DISTRO}-vision-opencv \
    ros-${ROS_DISTRO}-cv-bridge \
    ros-${ROS_DISTRO}-joint-state-controller \
    ros-${ROS_DISTRO}-pcl-* \
    ros-${ROS_DISTRO}-video-stream-opencv \
    ros-${ROS_DISTRO}-rgbd-launch \
    ros-${ROS_DISTRO}-openni2-camera \
    ros-${ROS_DISTRO}-ddynamic-reconfigure\
    ros-${ROS_DISTRO}-rqt \
    ros-${ROS_DISTRO}-rqt-common-plugins \
    ros-${ROS_DISTRO}-rqt-robot-plugins \
    ros-${ROS_DISTRO}-opencv-apps \
    ros-${ROS_DISTRO}-joy \
    ros-${ROS_DISTRO}-turtlebot3 \
    ros-${ROS_DISTRO}-turtlebot3-applications \
    ros-${ROS_DISTRO}-turtlebot3-navigation \
    ros-${ROS_DISTRO}-turtlebot3-simulations \
    ros-${ROS_DISTRO}-ar-track-alvar-msgs \
    ros-${ROS_DISTRO}-xacro \
    ros-${ROS_DISTRO}-gmapping \
    ros-${ROS_DISTRO}-ros-control \
    ros-${ROS_DISTRO}-diff-drive-controller \
    ros-${ROS_DISTRO}-four-wheel-steering-msgs \
    ros-${ROS_DISTRO}-urdf-geometry-parser \
    ros-${ROS_DISTRO}-jackal-description \
    ros-${ROS_DISTRO}-jackal-navigation \
    ros-${ROS_DISTRO}-jackal-viz \
    ros-${ROS_DISTRO}-warthog-description \
    ros-${ROS_DISTRO}-cartographer-ros \
    ros-${ROS_DISTRO}-map-server \
    ros-${ROS_DISTRO}-move-base \
    ros-${ROS_DISTRO}-joy \
    ros-${ROS_DISTRO}-ps3joy \
    ros-${ROS_DISTRO}-velodyne \
    ros-${ROS_DISTRO}-velodyne-pointcloud \
    ros-${ROS_DISTRO}-pointcloud-to-laserscan \
    ros-${ROS_DISTRO}-rospy-message-converter \
    && rm -rf /var/lib/apt/lists/*

COPY --from=nvidia/opengl:1.0-glvnd-runtime-ubuntu18.04 /usr/share/glvnd/egl_vendor.d/10_nvidia.json /usr/share/glvnd/egl_vendor.d/10_nvidia.json
ENV NVIDIA_VISIBLE_DEVICES ${NVIDIA_VISIBLE_DEVICES:-all}
ENV NVIDIA_DRIVER_CAPABILITIES ${NVIDIA_DRIVER_CAPABILITIES:+$NVIDIA_DRIVER_CAPABILITIES,}graphics

# user-specific arguments
ARG userid
ARG groupid
ARG workspacename
ARG username
ENV USERNAME=$username
ENV WORKSPACENAME=$workspacename

# user setup
ENV UID=$userid
ENV GID=$groupid
RUN mkdir -p /home/$username && \
    echo "${USERNAME}:x:${UID}:${GID}:${USERNAME},,,:/home/${USERNAME}:/bin/bash" >> /etc/passwd && \
    echo "${USERNAME}:x:${GID}:" >> /etc/group && \
    echo "${USERNAME} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${USERNAME} && \
    chmod 0440 /etc/sudoers.d/${USERNAME} && \
    chown ${UID}:${GID} -R /home/${USERNAME}

## vnc password / config
RUN mkdir /home/${USERNAME}/.Xauthority && \
    chown -R ${UID}:${GID} /home/${USERNAME}/.Xauthority

# setup ros
RUN printf "source /opt/ros/melodic/setup.bash \n\
FILE=/home/${USERNAME}/$workspacename/devel/setup.bash && test -f \$FILE && source \$FILE || true\n\
export ROS_MASTER_URI=http://ros-master:11311 \n\
export ROS_HOSTNAME=\$(hostname) \n\
export ROS_IP=\$(hostname -i) \n\
export PATH=/sbin/:\$PATH \n\
export TURTLEBOT3_MODEL=burger \n\
cd /home/${USERNAME}/$workspacename \
" >> /home/${USERNAME}/.bash_profile
#echo "export DISPLAY=host.docker.internal:0" >> /$username/.bash_profile

ENTRYPOINT ["/bin/bash", "-l", "-c"]
