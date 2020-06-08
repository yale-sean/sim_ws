#!/bin/bash

###
# Builds the workspace in the correct order
###

#set -x
set -e

#catkin_make -DCMAKE_BUILD_TYPE=Release -DCATKIN_WHITELIST_PACKAGES="darknet_msgs"
#catkin_make -DCMAKE_BUILD_TYPE=Release -DCATKIN_WHITELIST_PACKAGES="darknet_ros_msgs"
#catkin_make -DCMAKE_BUILD_TYPE=Release -DCATKIN_WHITELIST_PACKAGES="darknet_ros"
#catkin_make -DCMAKE_BUILD_TYPE=Release -DCATKIN_WHITELIST_PACKAGES="deeptrack_ros"
#catkin_make -DCMAKE_BUILD_TYPE=Release -DCATKIN_WHITELIST_PACKAGES="aruco;aruco_ros;aruco_msgs"
#catkin_make -DCMAKE_BUILD_TYPE=Release -DCATKIN_WHITELIST_PACKAGES="velodyne_driver;velodyne_pointcloud;velodyne_msgs;aruco_mapping;lidar_camera_calibration"
#catkin_make -DCMAKE_BUILD_TYPE=Release -DCATKIN_WHITELIST_PACKAGES="spencer_tracking_msgs"
#catkin_make -DCMAKE_BUILD_TYPE=Release -DCATKIN_WHITELIST_PACKAGES=""
