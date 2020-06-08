#!/bin/bash
VNC_COL_DEPTH=24
VNC_RESOLUTION=1280x1024

set -x
set -e


mkdir $HOME/.vnc
echo """#!/bin/bash
xrdp $HOME/.Xresources
startxfce4 &""" > $HOME/.vnc/xstartup
chmod 777 $HOME/.vnc/xstartup
cat $HOME/.vnc/xstartup
echo "00000000" | vncpasswd -f > $HOME/.vnc/passwd
cat $HOME/.vnc/passwd

#/bin/bash

USER=$USERNAME vncserver $DISPLAY -depth $VNC_COL_DEPTH -geometry $VNC_RESOLUTION
tail -f $HOME/.vnc/*$DISPLAY.log
#Xvnc :1 -ac -auth "/$HOME/.Xauthority" -geometry "$VNC_RESOLUTION" -depth 8 -rfbwait 120000 -rfbauth /$HOME/.vnc/passwd 2> /tmp/no_vnc_startup.log &
#sleep 5
#cat /tmp/no_vnc_startup.log

#xset -dpms &
#xset s noblank &
#xset s off &

#icewm-session > /tmp/wm.log &
#sleep 5
#cat /tmp/wm.log
