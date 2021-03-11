#!/bin/bash

###
# run a ros-bridge node
###

#set -x
set -e

#source $HOME/.bash_profile

# one node setup (flocked)
#source $(dirname $0)/build.sh

# stdbuf -o L #enables line buffering
stdbuf -o L roslaunch --wait rosbridge_server rosbridge_websocket.launch

# start the rosbridge with the ros-sharp file server
