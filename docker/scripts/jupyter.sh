#!/bin/bash

###
# run a node for jupyter
###

#set -x
set -e

# NO AUTH, you must tunnel this connection for security
jupyter notebook --generate-config --tokenUnicode ''

/usr/bin/tini jupyter notebook --port=8888 --no-browser --ip=0.0.0.0
