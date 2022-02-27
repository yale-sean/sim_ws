#!/bin/bash
# Run submission
# $1 = port (e.g.20), $2 = datapath
set -e
set -x

cd $HOME/sim_ws
catkin_make
source devel/setup.bash
package_name=$(rospack list-names | grep submission)
roscore -p 113$1
roslaunch --wait ./src/social_sim_ros/social_sim_ros/launch/submission_runner.launch submission_name:=$package_name port:=$1 datapath:=$2
