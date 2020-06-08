#!/bin/bash

###
# Check out required code
###

#set -x
set -e

SRC=$HOME/$WORKSPACENAME/src
mkdir -p $SRC
pushd $SRC

# clone a target repo if it doesn't exist, other wise prints "Skipping" and continues
clone_or_warn () {
  l=$#
  to_clone="${!l}"
  echo $to_clone
  bn=$(basename "$to_clone" .git)
  if [ -d "$bn" ]; then
    echo "Skipping $to_clone, $bn already exists"
  else
    git clone $@
  fi
}

# Dependencies
clone_or_warn --recursive https://github.com/RIVeR-Lab/apriltags_ros.git
clone_or_warn --recursive https://github.com/code-iai/iai_kinect2.git

# Study
clone_or_warn --recursive git@gitlab.com:interactive-machines/robot_abuse.git

# Perception
clone_or_warn --recursive git@gitlab.com:interactive-machines/perception/alphapose_ros.git
#clone_or_warn --recursive git@gitlab.com:interactive-machines/perception/videopose3d_ros.git
clone_or_warn --recursive -j8 git@gitlab.com:interactive-machines/perception/openface2_ros_wrapper.git

#tools
clone_or_warn --recursive git@gitlab.com:interactive-machines/perception/img_ros_audiovisual_tools.git
clone_or_warn --recursive git@gitlab.com:interactive-machines/perception/spontaneous_smiles.git

popd
