# Slam

OrbSlam2 with a variety of input sources using ROS as the messaging middleware, running in separate docker containers to simulate a distributed system.

The aim is not to support every single distribution/version combination, but to demonstrate the process of setting up such a system. Therefore the build scripts are intentionally kept simple, with as little usage of arguments/parameters as possible, supporting only ROS melodic in ubuntu 18.04 containers.


## Set up

- Build all docker images with `./build_all.sh`. This will also create a new ros network for the containers to communicate. Since ros is the common middleware, all images are based on the official image `ros:melodic-ros-core`

Some images are large and may not be required. To select which images are built add the following flags: `--slam`, `--kitti`, `--airsim`, `--gazebo`, `--usb_cam`

```
./build_all.sh --slam --kitti --airsim --gazebo --usb_cam
```


