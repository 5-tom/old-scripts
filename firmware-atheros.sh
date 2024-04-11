#!/bin/bash
set -e
cd $HOME

sudo mkdir -p /etc/apt/sources.list.d
echo "deb http://deb.debian.org/debian/ bookworm non-free-firmware" | sudo tee /etc/apt/sources.list.d/non-free.list
sudo apt update
sudo apt install -y firmware-atheros
sudo gio trash /etc/apt/sources.list.d/non-free.list
sudo apt update