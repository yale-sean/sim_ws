#!/bin/bash

set -e
set -x

sudo ./scripts/bootstrap.sh noetic
sudo ./scripts/packages.sh noetic
./scripts/checkout.sh
