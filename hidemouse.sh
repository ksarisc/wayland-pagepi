#!/bin/bash
# hide mouse in wayland raspbian

sudo apt install interception-tools interception-tools-compat


sudo apt install -y cmake
cd ~
git clone https://gitlab.com/interception/linux/plugins/hideaway.git
cd hideaway
cmake -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build
sudo cp /home/user/hideaway/build/hideaway /usr/bin
sudo chmod +x /usr/bin/hideaway


sudo echo "- JOB: intercept $DEVNODE | hideaway 4 10000 10000 -512 -256 | uinput -d $DEVNODE
DEVICE:
EVENTS:
 EV_REL: [REL_X, REL_Y]" > /etc/interception/udevmon.d/config.yaml











