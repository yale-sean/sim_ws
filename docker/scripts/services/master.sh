#!/bin/bash

###
# run a ros master node
###

#set -x
set -e

#source $HOME/.bash_profile

# one node setup (flocked)
#source $(dirname $0)/build.sh

stdbuf -o L roscore
