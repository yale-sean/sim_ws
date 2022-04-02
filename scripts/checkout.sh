#!/bin/bash

set -e
set -x

# $1: remote origin, $2: branch, $3: directory path
git-clone-idem(){
    if [ ! -d "$3" ] || [ ! -d "$3/.git" ]
    then
        rm -fr $3
        git clone --branch $2 $1
        echo -e "Cloned repo $1 on branch $2"
    fi
    pushd $3
    BRANCH=$(git rev-parse --abbrev-ref HEAD)
    if [ "$BRANCH" != "$2" ]
    then
        git fetch && git checkout $2
    fi
    git submodule update --init --recursive
    popd
}


mkdir -p src
pushd src
git-clone-idem https://github.com/yale-sean/social_sim_ros main "./social_sim_ros"
git-clone-idem https://github.com/Unity-Technologies/ROS-TCP-Endpoint.git "v0.6.0" "./ROS-TCP-Endpoint"
git-clone-idem https://github.com/yale-img/kuri.git noetic-devel "./kuri"
git-clone-idem https://github.com/ros-perception/depthimage_to_laserscan.git melodic-devel "./depthimage_to_laserscan"
git-clone-idem https://github.com/nathantsoi/bag2video.git master "./bag2video"

popd
source /opt/ros/noetic/setup.bash
catkin_make
