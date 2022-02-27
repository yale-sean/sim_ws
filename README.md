# Social Environment Autonomous Navigation 2.0

This is a [catkin workspace](http://wiki.ros.org/catkin/workspaces) project for SEAN: Social Environment for Autonomous Navigation

## Source Repositories

Other repositories for the project are:

  - ROS project: https://github.com/yale-sean/social_sim_ros

  - Unity Project: https://github.com/yale-sean/social_sim_unity

  - Documentation: https://github.com/yale-sean/social-sim-docs

  - Dockerized Catkin Workspace (this repository): https://github.com/yale-sean/sim_ws
  
## Installation

Checkout this repository to `~/sim_ws`

### Linux Installation

Install docker and nvidia-docker, as described below, by running this one script on Linux:

```
curl -L https://gist.githubusercontent.com/nathantsoi/e668e83f8cadfa0b87b67d18cc965bd3/raw/setup_docker.sh | sudo bash
```

### Mac Installation

ROS will be run in an Ubuntu Docker container on your Mac. Install the following tools to enable this:

- [Docker for Mac](https://docs.docker.com/docker-for-mac/install/)

```
brew install --cask docker
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

## Packer

```
packer build packer/templates/aws_gpu_interactive_20_04.pkr.hcl
```

To debug:

```
packer build -debug packer/templates/aws_gpu_interactive_20_04.pkr.hcl
```

You'll see a line like, from which you should copy the key name:

```
amazon-ebs.sean-interactive: Saving key for debug purposes: ec2_sean-interactive.pem
```

Copy the IP from:

```
amazon-ebs.sean-interactive: Private IP: 10.5.198.30
```

The last step before the script is:
```
==> amazon-ebs.sean-interactive: Pausing after run of step 'StepSetGeneratedData'. Press enter to continue.
```

Then run:

```
ssh -i ec2_sean-interactive.pem ubuntu@10.5.198.30
```
