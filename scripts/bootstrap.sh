#!/bin/bash

set -e
set -x

ROS_DISTRO=$1

apt-get update
apt-get install --no-install-recommends -y \
    lsb-release \
    gnupg2

# setup keys
apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
# setup sources.list
echo "deb http://packages.ros.org/ros/ubuntu `lsb_release -sc` main" > /etc/apt/sources.list.d/ros-latest.list

# install tools
apt-get update
apt-get install --no-install-recommends -y \
    tmux \
    tmuxinator \
    dirmngr \
    apt-utils \
    wget \
    sudo \
    vim \
    xauth \
    iproute2 \
    net-tools \
    gdb \
    g++ \
    build-essential

# install bootstrap tools
apt-get install --no-install-recommends -y \
    python3-catkin-tools \
    python3-rosinstall-generator \
    python3-rosdep \
    python3-rosinstall \
    python3-vcstools \
    libatlas-base-dev \
    libbullet-dev \
    libjpeg-dev \
    libpng-dev \
    libblas-dev \
    libz-dev \
    libpcap-dev \
    libsvm-dev \
    libsdl-image1.2-dev \
    libsdl-dev \
    pcl-tools \
    python3-pip \
    python3-setuptools \
    python3-venv \
    xsltproc

# bootstrap rosdep
rosdep init || true
#rosdep update

# install ros packages
apt-get install -y \
    ros-${ROS_DISTRO}-desktop \

# pips
pip3 install virtualenv

apt-get clean && rm -rf /var/lib/apt/lists/*
