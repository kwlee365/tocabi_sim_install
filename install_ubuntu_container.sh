#!/bin/bash
# ========================================================================
# Apache License 2.0
# Copyright (c) 2024, DYROS Robotics
#
# TOCABI Simulation Container Setup Script
# This script installs Distrobox and creates an Ubuntu 20.04 container 
# for running TOCABI Simulation on Ubuntu 24.04.
# ========================================================================

set -e  # Stop script on error

echo "[Step 1] Installing Distrobox and Podman..."
sudo apt update -y
sudo apt install -y curl podman
curl -s https://raw.githubusercontent.com/89luca89/distrobox/main/install | sudo sh

echo "[Step 2] Creating Ubuntu 20.04 container using Distrobox..."
mkdir -p ~/ubuntu-20-04  # Create a directory for the container's home

distrobox create --image ubuntu:20.04 \
                 --name ubuntu-20-04 \
                 --hostname ubuntu-20-04 \
                 --home ~/ubuntu-20-04 \
                 --nvidia

echo "[✅ Setup Complete!] To enter the container, run: distrobox enter ubuntu-20-04"

