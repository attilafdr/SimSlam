#!/bin/bash

# Create docker network
docker network create --driver=bridge --subnet=172.18.0.0/16 rosnet

set -ex

# Build base image
docker build -f Dockerfile-base --build-arg UID=$(id -u) --build-arg GID=$(id -g) -t simslam/base:melodic .

# Build image to play Kitti data
cd Kitti && docker build -f Dockerfile-kitti -t simslam/kitti:melodic . && cd ..

# Build UsbCam image
cd UsbCam && docker build -f Dockerfile-usbcam -t simslam/usbcam:melodic . && cd ..

# Build OrbSlam2 image
cd OrbSlam2 && docker build -f Dockerfile-orbslam2 -t simslam/orbslam2:melodic . && cd ..
