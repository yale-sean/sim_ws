#!/bin/bash

set -e
set -x

sudo ./scripts/bootstrap.sh melodic
sudo ./scripts/packages.sh melodic
./scripts/checkout.sh
