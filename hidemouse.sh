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




 

cd ~
nano myscript.sh

Paste

#!/bin/bash
chromium-browser --new-window --window-position=0,0 --window-size=3840,2160 --incognito --user-data-dir=/home/$USER/.config/chromium2 --enable-features=OverlayScrollbar,OverlayScrollbarFlashAfterAnyScrollUpdate,OverlayScrollbarFlashWhenMouseEnter --app=https://twitch.tv &

Save


chmod +x myscript.sh 



sudo nano $HOME/.config/wayfire.ini 

Add
[autostart]
rumeman = $HOME/myscript.sh


#.config/wf-panel-pi.ini ADD the following:
#autohide=true
#autohide_duration=500
















