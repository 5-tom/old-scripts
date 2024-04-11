#!/bin/bash
set -e
cd $HOME

cd $HOME/Documents/work/programs
#https://developer.android.com/studio/
#https://gradle.org/releases/
sudo mkdir -p /etc/apt/sources.list.d
echo "deb http://deb.debian.org/debian/ bullseye-backports non-free" | sudo tee /etc/apt/sources.list.d/non-free.list
sudo apt update
sudo apt install -y openjdk-11-jdk-headless
sudo gio trash /etc/apt/sources.list.d/non-free.list
sudo apt update
echo "export PATH=$HOME/Documents/work/programs/gradle-7.6/bin:$PATH" >> $HOME/.zshrc
echo "export ANDROID_SDK_ROOT=$HOME/Android/Sdk" >> $HOME/.zshrc
echo "export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64" >> $HOME/.zshrc
