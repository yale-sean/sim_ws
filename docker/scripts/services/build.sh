#!/bin/bash

###
# build the workspace, flocked
###

set -x
set -e

cd $HOME/$WORKSPACENAME

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
SCRIPTNAME=$(basename $0)

# in subshell
(
  # acquire lock or exit gracefully
  (flock -n 200) || (echo "flock failed to acquire lock, exiting gracefully" && exit 1)
  echo "Building workspace"
  # env
  source $HOME/.bash_profile
  # build everything
  catkin_make -DCMAKE_BUILD_TYPE=Release -DCATKIN_WHITELIST_PACKAGES=""
  # lock release
) 200>$DIR/build.lock
