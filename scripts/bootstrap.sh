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
    python-catkin-tools \
    python-rosinstall-generator \
    python-rosdep \
    python-rosinstall \
    python-vcstools \
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

# bootstrap rosdep
rosdep init || true
rosdep update

# install ros packages
apt-get install -y \
    ros-${ROS_DISTRO}-ros-core \
    ros-${ROS_DISTRO}-ros-base \
    ros-${ROS_DISTRO}-robot \
    ros-${ROS_DISTRO}-desktop \
    ros-${ROS_DISTRO}-desktop-full \

# pips
pip install virtualenv future

apt-get clean && rm -rf /var/lib/apt/lists/*
