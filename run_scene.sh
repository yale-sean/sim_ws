#!/bin/bash
trap "kill 0" EXIT

while getopts "n:s:t:v:e:i:" flag
do
    case "${flag}" in
        n) scenario_name=${OPTARG};;
        s) start_locs=${OPTARG};;
        t) target_locs=${OPTARG};;
		v) environment=${OPTARG};;
		e) exp_id=${OPTARG};;
		i) trial_id=${OPTARG};;
    esac
done

help()
{
	# Display help
	echo
	echo "Syntax: run_scene [-n|s|t|i]"
	echo "options:"
	echo "-n     The name of the scenario(s), e.g. Empty1_Density0." # TODO: put a real scenario name here
	echo "       All options: Empty1_Density0,JoinGroup1_Density0,JoinGroup2_Density0"
	echo "                    LeaveGroup1_Density0,LeaveGroup2_Density0,NavigateDownPathway1_Density1"
	echo "                    NavigateDownPathway1_Density2,NavigateDownPathway2_Density1,NavigateDownPathway2_Density2"
	echo "                    NavigateDownPathway3_Density1,NavigateDownPathway3_Density2"
	echo "                    CrossPath1_Density1,CrossPath1_Density2"
	echo "                    CrossPathJoinGroup1_Density1,CrossPathJoinGroup1_Density2"
	echo "-s     Array of start location(s) corresponding to scenarios from 0-4, e.g. 1,3,4"
	echo "-t     Array of target location(s) corresponding to scenariosfrom 0-4, e.g. 0,1,4"
	echo "-v 	 Environment, one of: [Warehouse, Outdoor]"

	echo " [BELOW CURRENTLY NOT USED]"
	echo "-e     Name of experiment, e.g. prelim"
	echo "-i     Name of unique trial identifier, e.g. 001"
	echo
}


#if [ $# -eq 0 ]
#  then
#    help
#	exit
#fi


# have default scene, start locations, target locations if none given?
if [ -z "$scenario_name" ]; then scenario_name="Empty1_Density0"; fi
if [ -z "$start_locs" ]; then start_locs="0"; fi
if [ -z "$target_locs" ]; then target_locs="0"; fi
if [ -z "$exp_id" ]; then id="default_exp_id"; fi
if [ -z "$trial_id" ]; then id="default_trial_id"; fi

social_sim_unity=$HOME/sim_ws/social_sim_unity
echo "Checking for symlink $social_sim_unity"
if [[ -L ${social_sim_unity} && -e ${social_sim_unity} ]] ; then
  echo "."
  ls -lah $social_sim_unity
else
  echo "Please symlink your social_sim_unity directory in $HOME/sim_ws"
  echo "e.g. 'cd $HOME/sim_ws && ln -s $HOME/social_sim_unity' if your unity project folder is in your home directory"
  exit
fi

# TODO: parameterize?
echo "Checking for Unity binary"
UNITY_BINARY="$HOME/sim_ws/social_sim_unity/Build/${environment}RobotControl.x86_64"

echo "Starting Unity Scene with given parameters"

#DATAPATH="data/${exp_id}/${trial_id}"
#mkdir -p $DATAPATH
#echo $DATAPATH

#timestamp=$(date +%T)


# start ROS before running binary
# Assuming we are in sim_ws directory
roscore &
echo "Starting all ros nodes in kuri_manual_record.launch, to see the logs, 'tail -f /tmp/ros-run.log'"
roslaunch --wait social_sim_ros kuri_manual_record.launch >> /tmp/ros-run.log 2>&1 &

sleep 5


# (!) we can test this script by manually running Unity
$UNITY_BINARY -scenarios $scenario_name -robot_locations $start_locs -target_locations $target_locs &

wait $!

echo "Done"
