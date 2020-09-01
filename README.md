# Social Sim Catkin Workspace

This is a [catkin workspace](http://wiki.ros.org/catkin/workspaces) project for SEAN: Social Environment for Autonomous Navigation

## Source Repositories

Other repositories for the project are:

  - ROS project: https://github.com/yale-img/social_sim_ros

  - Unity Project: https://github.com/yale-img/social_sim_unity

  - Documentation: https://github.com/yale-img/social-sim-docs

  - Dockerized Catkin Workspace (this repository): https://github.com/yale-img/sim_ws
  
## Installation

Checkout this repository to `~/sim_ws`

#### Docker

Install [docker](https://docs.docker.com/engine/install/ubuntu/), [nvidia docker](https://github.com/NVIDIA/nvidia-docker) and the [nvidia container runtime](https://github.com/nvidia/nvidia-container-runtime), and [docker-compose](https://docs.docker.com/compose/install/)

Though nvidia-docker is deprecated, you'll need the following in `/etc/docker/daemon.json` (edit with sudo):

```
{
    "runtimes": {
        "nvidia": {
            "path": "/usr/bin/nvidia-container-runtime",
            "runtimeArgs": []
        }
    }
}
```

Then restart docker:

```
sudo systemctl restart docker
```

Install yarn: https://classic.yarnpkg.com/en/docs/install

Then cd into `~/sim_ws` and run: `yarn build`, `yarn up`, and `yarn shell`, then `catkin build -c`

Run `yarn shell` to open more terminals in the docker container
