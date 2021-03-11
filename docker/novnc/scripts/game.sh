#!/bin/bash

set -x
set -e

# read named params
# assumes only named params in the format "-key value"
for (( i=1; i <= "$#"; i+=2)); do
  KEY="${!i}"
  j=$((i+1))
  VALUE="${!j}"
  echo $KEY=$VALUE
  case "$KEY" in
          -scene)              SCENE=${VALUE} ;;
          *)
  esac
done

# Scenes must match the name in the Unity build window
if [ "$SCENE" = "Scenes/AgentControlWarehouseScene" ]; then
   SCENE="warehouse"
fi
if [ "$SCENE" = "Scenes/AgentControlLabScene" ]; then
   SCENE="lab"
fi

echo SCENE is $SCENE

# enable vgl
/opt/VirtualGL/bin/vglserver_config -config +s +f +t

# start novnc, websockify, and virtualgl via supervisord
/usr/bin/supervisord
# start ros
/root/scripts/ros.sh $SCENE
# wait for the rosbridge to come up
while ! echo exit | nc localhost 9090; do
  sleep 2
done

# only for debugging
#/usr/bin/startxfce4 --replace > /root/wm.log 2>&1 &
cp /etc/xdg/xfce4/panel/default.xml /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml
xfce4-session

# launch the game with all passed params
#vglrun -display :1 /root/bin/SurveyGame.x86_64 "$@"
