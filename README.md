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

### Linux Installation

Install docker and nvidia-docker, as described below, by running this one script on Linux:

```
sudo ./scripts/setup_docker.sh
```

After running the script

### Mac Installation

ROS will be run in an Ubuntu Docker container on your Mac. Install the following tools to enable this:

- [Docker for Mac](https://docs.docker.com/docker-for-mac/install/)

```
brew install --cask docker
```


### Manual Linux Docker Installation

Manual setup: The following is only required if you did NOT run the `./scripts/setup_docker.sh` file mentioned above.

Install [docker](https://docs.docker.com/engine/install/ubuntu/), [nvidia docker](https://github.com/NVIDIA/nvidia-docker) and the [nvidia container runtime](https://github.com/nvidia/nvidia-container-runtime).

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

## Usage

The `./container` script wraps the `docker` command.

Build the container once or when the `ros/Dockerfile` or `rosmac/Dockerfile` changes:

To build the container:

 - On Linux, run: `./container build ros`

 - On Mac, run: `./container build rosmac`

To build start container (e.g. run the virtual machine):

 - On Linux, run: `./container start ros`

 - On Mac, run: `./container start rosmac`

To enter a shell on the running container:

 - On Linux, run: `./container shell ros`

 - On Mac, run: `./container shell rosmac`

The `shell` command can be run multiple times.
