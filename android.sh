#!/bin/bash

wget "https://dl.google.com/android/repository/commandlinetools-linux-9123335_latest.zip" -O /tmp/commandlinetools.zip
mkdir ~/Android
cd ~/Android
unzip /tmp/commandlinetools.zip
cd cmdline-tools
mkdir tools
mv -i * tools

set -e
#run the following and add it to your shell's rc file
cat <<'EOF'>> $HOME/.zshrc
export ANDROID_HOME=$HOME/Android
export PATH=$ANDROID_HOME/cmdline-tools/tools/bin/:$PATH
export PATH=$ANDROID_HOME/emulator/:$PATH
export PATH=$ANDROID_HOME/platform-tools/:$PATH
EOF

source $HOME/.zshrc

sdkmanager --list
#change version if needed
yes|sdkmanager --install "platform-tools" "platforms;android-29" "build-tools;29.0.2"

#if you don't need the emulator you can save a lot of space by deleting it
#rm -fr ../emulator
#rm -fr ../tools
