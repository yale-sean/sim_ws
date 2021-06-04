#!/bin/bash

set -e
set -x

mkdir -p src
pushd src
git clone git@github.com:yale-sean/social_sim_ros social_sim_ros
pushd social_sim_ros
git submodule update --init --recursive
popd
git clone --branch melodic-devel https://github.com/ros-planning/navigation
# only for the real kuri
#git clone https://github.com/yale-img/kuri.git
popd
catkin_make
