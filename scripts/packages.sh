#!/bin/bash

ROS_DISTRO=$1

apt-get update && apt-get install -y \
    ros-${ROS_DISTRO}-openni2-* \
    ros-${ROS_DISTRO}-usb-cam \
    ros-${ROS_DISTRO}-rosbash \
    ros-${ROS_DISTRO}-tf2-sensor-msgs \
    ros-${ROS_DISTRO}-tf2-tools \
    ros-${ROS_DISTRO}-rosbridge-suite \
    ros-${ROS_DISTRO}-vision-opencv \
    ros-${ROS_DISTRO}-cv-bridge \
    ros-${ROS_DISTRO}-joint-state-controller \
    ros-${ROS_DISTRO}-pcl-* \
    ros-${ROS_DISTRO}-video-stream-opencv \
    ros-${ROS_DISTRO}-rgbd-launch \
    ros-${ROS_DISTRO}-openni2-camera \
    ros-${ROS_DISTRO}-ddynamic-reconfigure\
    ros-${ROS_DISTRO}-rqt \
    ros-${ROS_DISTRO}-rqt-common-plugins \
    ros-${ROS_DISTRO}-rqt-robot-plugins \
    ros-${ROS_DISTRO}-opencv-apps \
    ros-${ROS_DISTRO}-joy \
    ros-${ROS_DISTRO}-xacro \
    ros-${ROS_DISTRO}-gmapping \
    ros-${ROS_DISTRO}-ros-control \
    ros-${ROS_DISTRO}-diff-drive-controller \
    ros-${ROS_DISTRO}-four-wheel-steering-msgs \
    ros-${ROS_DISTRO}-urdf-geometry-parser \
    ros-${ROS_DISTRO}-map-server \
    ros-${ROS_DISTRO}-move-base \
    ros-${ROS_DISTRO}-joy \
    ros-${ROS_DISTRO}-velodyne \
    ros-${ROS_DISTRO}-velodyne-pointcloud \
    ros-${ROS_DISTRO}-pointcloud-to-laserscan \
    ros-${ROS_DISTRO}-rospy-message-converter \
    ros-${ROS_DISTRO}-people-msgs \
    ros-${ROS_DISTRO}-compressed-image-transport \
    ros-${ROS_DISTRO}-polled-camera \
    ros-${ROS_DISTRO}-control-toolbox \
    ros-${ROS_DISTRO}-sbpl \
    ros-${ROS_DISTRO}-gazebo-ros-control \
    ros-${ROS_DISTRO}-navigation \
    ros-${ROS_DISTRO}-navigation-experimental


apt-get clean && rm -rf /var/lib/apt/lists/*
