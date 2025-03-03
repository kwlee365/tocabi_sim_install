#!/bin/bash
# ========================================================================
# Apache License 2.0
# Copyright (c) 2024, DYROS Robotics
#
# TOCABI Simulation Installation Script
# This script installs ROS Noetic and TOCABI Simulation inside an 
# Ubuntu 20.04 container (created via Distrobox).
# ========================================================================

set -e  # Stop script on error

echo "[Step 1] Installing ROS Noetic..."
sudo apt update -y
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu focal main" > /etc/apt/sources.list.d/ros-latest.list'
curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -
sudo apt update -y
sudo apt install -y ros-noetic-desktop-full python3-rosdep python3-rosinstall python3-rosinstall-generator python3-wstool build-essential git
sudo rosdep init
rosdep update
sudo apt install -y python3-catkin-tools
echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc
source ~/.bashrc

echo "[Step 2] Installing TOCABI Simulation and dependencies..."
sudo apt update -y
sudo apt install -y cmake g++ libeigen3-dev libyaml-cpp-dev libjsoncpp-dev qtbase5-private-dev libqt5x11extras5*

# Create catkin workspace and clone necessary repositories
mkdir -p ~/catkin_ws/src
cd ~/catkin_ws/src
git clone --recurse-submodules https://github.com/kwlee365/dyros_tocabi_v2
git clone https://github.com/saga0619/tocabi_cc
git clone https://github.com/saga0619/tocabi_avatar
git clone https://github.com/saga0619/tocabi_gui
git clone https://github.com/saga0619/mujoco_ros_sim

# Install required libraries manually instead of install_prereq.sh
mkdir -p ~/lib && cd ~/lib

# Install RBDL
echo "[Installing RBDL...]"
git clone --recursive https://github.com/saga0619/rbdl-orb
cd rbdl-orb
mkdir build && cd build
cmake ..
make all
echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib' >> ~/.bashrc
sudo ldconfig
sudo make install

# Install qpOASES
echo "[Installing qpOASES...]"
cd ~/lib
git clone https://github.com/saga0619/qpoases
cd qpoases
mkdir build && cd build
cmake ..
make all
sudo make install

# Install MSCL
echo "[Installing MSCL...]"
cd ~/lib
wget https://github.com/LORD-MicroStrain/MSCL/releases/download/v52.2.1/c++-mscl_52.2.1_amd64.deb
sudo dpkg -i c++-mscl_52.2.1_amd64.deb

# Build the catkin workspace using catkin build
cd ~/catkin_ws
source /opt/ros/noetic/setup.bash
catkin build
echo "source ~/catkin_ws/devel/setup.bash" >> ~/.bashrc
source ~/.bashrc

echo "[Installation Complete!] To use TOCABI Simulation, enter the container and launch it:"
echo "    distrobox enter ubuntu-20-04"
echo "    roslaunch tocabi_controller simulation.launch"

