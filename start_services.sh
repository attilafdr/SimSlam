#!/bin/bash

set -ex

# Start Kitti in detached mode, ROS_MASTER_URI set to slam container
docker rm -f kitti
docker run --rm -t -d \
    --name="kitti" \
    --net=rosnet \
    --ip=172.18.0.11 \
    --hostname="kitti" \
    -e ROS_HOSTNAME="kitti" \
    -e ROS_MASTER_URI="http://172.18.0.10:11311" \
    -v $(pwd)/Kitti/data:/home/simslam/data \
    simslam/kitti:melodic
    
# Start UsbCam in detached mode, ROS_MASTER_URI set to slam container
docker rm -f usbcam
docker run --rm -t -d --privileged\
    --name="usbcam" \
    --net=rosnet \
    --ip=172.18.0.12 \
    --hostname="usbcam" \
    -e ROS_HOSTNAME="usbcam" \
    -e ROS_MASTER_URI="http://172.18.0.10:11311" \
    -v $(pwd)/UsbCam/calibration:/home/simslam/calibration \
    simslam/usbcam:melodic

# Start slam container with display and attach
xhost +local:docker
docker rm -f orbslam2
docker run -ti --rm --privileged --ipc=host --gpus=all \
    --name="orbslam2" \
    --net=rosnet \
    --ip=172.18.0.10 \
    --hostname="orbslam2" \
    -e ROS_IP="172.18.0.10" \
    -e ROS_MASTER_URI="http://172.18.0.10:11311" \
    -e "DISPLAY=$DISPLAY" \
    -e "QT_X11_NO_MITSHM=1" \
    -v "/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    -v "$HOME/.Xauthority:/root/.Xauthority:rw" \
    --cap-add=SYS_PTRACE \
    -v $(pwd)/OrbSlam2/src:/home/simslam/ros_ws/src \
    simslam/orbslam2:melodic bash

