#!/bin/bash

set -e
set -x

if ! command -v brew &> /dev/null
then
    echo "installing brew"
    curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh
fi

# install the smallest, fastest version of mamba
brew install --cask mambaforge
mamba init "$(basename "${SHELL}")"
mamba create -y -n noetic python=3.8
mamba activate noetic 

# Install ros noetic in the conda env
# https://github.com/RoboStack/ros-noetic#installation
mamba config --env --add channels conda-forge
mamba config --env --add channels robostack
mamba config --env --set channel_priority strict

# available packages: https://robostack.github.io/noetic.html
mamba install -y ros-noetic-desktop \
  ros-noetic-navigation \
  ros-noetic-ros-control \
  ros-noetic-joy \
  ros-noetic-image-geometry \
  ros-noetic-compressed-image-transport \
  ros-noetic-polled-camera \
  ros-noetic-camera-info-manager \
  ros-noetic-control-toolbox \
  ros-noetic-tf2-sensor-msgs \
  ros-noetic-sbpl \
  ros-noetic-people-msgs \
  ros-noetic-four-wheel-steering-msgs \
  ros-noetic-urdf-geometry-parser \
  ros-noetic-gazebo-ros \
  compilers \
  cmake \
  pkg-config \
  make \
  ninja

# fix per https://github.com/RoboStack/ros-noetic/issues/180#issuecomment-948074536
mamba install orocos-kdl=1.5.0 python-orocos-kdl=1.5.0

# check xcode config
echo `xcode-select -p`
# reset the config
sudo xcode-select -r

# In case of the cmath/math.h sign bit error, see: # fix per https://github.com/RoboStack/ros-noetic/issues/180
# switch xcode to the command line tools version
#sudo xcode-select -s /Library/Developer/CommandLineTools
# remove 10.15 (https://stackoverflow.com/questions/58628377/catalina-c-using-cmath-headers-yield-error-no-member-named-signbit-in-th)
#sudo rm -rf /Library/Developer/CommandLineTools/SDKs/MacOSX10.15.sdk
# you may need to create an empty /Library/Developer/CommandLineTools/SDKs/MacOSX10.15.sdk/usr/include directory


#ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
#
#export ROS_PKG=desktop_full
#export ROS_DISTRO=noetic
#export ROS_ROOT=/opt/ros/${ROS_DISTRO}
#export ROS_PYTHON_VERSION=3
#export CATKIN_SHELL=zsh
#
## Install homebrew
#/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
#
## Homebrew
#brew tap nathantsoi/homebrew-ros-kinetic
#
## Python
#brew install python3
#python3 -m pip install -U pip
#python3 -m pip install wxPython
#python3 -m pip install -U \
#  wstool \
#  rosdep \
#  rosinstall \
#  rosinstall_generator \
#  rospkg \
#  catkin-pkg \
#  catkin_tools \
#  sphinx \
#  vcstool \
#  Distribute \
#  empy
#
## Link catkin to catkin_pkg
#pushd /usr/local/lib/python3.9/site-packages
#ln -s catkin_pkg catkin
#popd
#
## Make install dir
#sudo mkdir -p /opt/ros/noetic
#sudo chown -R $USER:wheel /opt/ros/noetic
#
## Make isolated env
#mkdir -p ~/ros_catkin_ws
#cd ~/ros_catkin_ws
#
## Update rosdep
#rosdep init
#rosdep update 
#
## Pull required source
#rosinstall_generator ${ROS_PKG} --rosdistro ${ROS_DISTRO} --deps --tar > ${ROS_DISTRO}-${ROS_PKG}.rosinstall
#mkdir -p src 
#vcs import --input ${ROS_DISTRO}-${ROS_PKG}.rosinstall ./src
#
## Patches
#for i in $ROOT/patches/macos/*.patch; do patch -p0 < $i; done
#
## Build
#python3 ./src/catkin/bin/catkin_make_isolated --install --install-space ${ROS_ROOT} -DCATKIN_WORKSPACES=/usr/local -DCMAKE_BUILD_TYPE=Release
#
#
