#!/bin/bash

#https://github.com/VSCodium/vscodium/discussions/1487

mkdir $HOME/snap_tmp
cp /var/lib/snapd/snaps/codium_* $HOME/snap_tmp
cd $HOME/snap_tmp
sudo unsquashfs codium_*.snap

#in vscodium, go to Help > Toggle Developer Tools > Console, and look at WIN and LOSS to see what to add

sudo sed -i 's/"GitHub.copilot": ["inlineCompletionsAdditions"],/"GitHub.copilot": ["inlineCompletionsAdditions", "terminalDataWriteEvent"],/' squashfs-root/usr/share/codium/resources/app/product.json
sudo snap try squashfs-root

device_code=$(curl https://github.com/login/device/code -X POST -d 'client_id=01ab8ac9400c4e429b23&scope=user:email' | cut -d '=' -f 2 | cut -d '&' -f 1)

user_code=$(curl https://github.com/login/device/code -X POST -d 'client_id=01ab8ac9400c4e429b23&scope=user:email' | cut -d '=' -f 5 | cut -d '&' -f 1)

echo "user_code is: $user_code"

xdg-open "https://github.com/login/device/"

echo "Do you want to proceed? (y/n)"
case "$1" in
	y)
		true ;;
	*)
		exit 1 ;;
esac

curl https://github.com/login/oauth/access_token -X POST -d "client_id=01ab8ac9400c4e429b23&scope=user:email&device_code=${device_code}&grant_type=urn:ietf:params:oauth:grant-type:device_code"
