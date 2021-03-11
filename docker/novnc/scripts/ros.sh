#!/bin/bash

set -e
set -x

source /opt/ros/melodic/setup.bash
cd /root/sim_ws
catkin_make
source devel/setup.bash
cd tmux/jackal_${1}_random_dest
tmuxinator &