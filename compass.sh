#!/bin/bash
set -e
cd $HOME

wget https://downloads.mongodb.com/compass/mongodb-compass_1.42.5_amd64.deb
sudo dpkg -i mongodb-compass_1.42.5_amd64.deb
rm mongodb-compass_1.42.5_amd64.deb
