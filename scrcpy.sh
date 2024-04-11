#!/bin/bash
cd $HOME
set -e

sudo apt install -y git obs-studio v4l-utils v4l2loopback-dkms
sudo apt install -y libsdl2-2.0-0 gcc pkg-config meson ninja-build libsdl2-dev libavcodec-dev libavdevice-dev libavformat-dev libavutil-dev libusb-1.0-0 libusb-1.0-0-dev
git clone https://github.com/Genymobile/scrcpy
cd scrcpy && ./install_release.sh
cd $HOME && gio trash scrcpy
echo "alias cam-start='sudo modprobe v4l2loopback devices=2 video_nr=10 && scrcpy --v4l2-sink=/dev/video10'" >> .zshrc
echo "alias cam-stop='sudo rmmod v4l2loopback'" >> .zshrc
