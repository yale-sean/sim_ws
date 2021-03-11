#!/bin/bash

###
# run an nginx node
###

#set -x
set -e

# stdbuf -o L #enables line buffering
stdbuf -o L sudo nginx -g 'daemon off;'
