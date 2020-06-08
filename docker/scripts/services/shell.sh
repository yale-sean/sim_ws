#!/bin/bash

###
# run a ros shell
###

#set -x
set -e

#source $HOME/.bash_profile

## one node setup (flocked)
#if [ -z ${SKIP_BUILD+x} ]; then
#  source $(dirname $0)/build.sh
#else
#  echo "Skipping build because the SKIP_BUILD env var is set.";
#fi

echo "shell is ready"
echo "if you ran 'yarn up', now you can attach to your ROS shell with: 'yarn shell'"

/bin/bash
