#!/bin/bash

#read -p "Enter Kit Station #: " stationNo
stationNo="120"
defaultUrl="http://climmtcreport:11111/apps/kitstation"

screenWidth=1920
screenHeight=1080

echo "Setting up IP Address"
sudo cat >> /etc/network/interfaces <<END

auto enp0s3
iface enp0s3 inet static
    address 10.50.1.${stationNo}
    gateway 10.50.1.1
    netmask 255.255.255.0
    network 10.50.1.0
    broadcast 10.50.1.255
END

echo "Running configuration tasks"
# Via https://gist.github.com/damoclark/ab3d700aafa140efb97e510650d9b1be
# Execute the config options starting with 'do_' below
grep -E -v -e '^\s*#' -e '^\s*$' <<END | \
sed -e 's/$//' -e 's/^\s*/\/usr\/bin\/raspi-config nonint /' | bash -x -
#
# Drop this file in SD card root. After booting run: sudo /boot/setup.sh
# --- Begin raspi-config non-interactive config option specification ---
# Hardware Configuration
do_boot_wait 0            # Turn on waiting for network before booting
do_boot_splash 1          # Disable the splash screen
do_overscan 1             # Enable overscan
do_camera 1               # Enable the camera
do_ssh 0                  # Enable remote ssh login
# System Configuration
do_configure_keyboard us
do_hostname KitStation${stationNo}
do_change_timezone America/Indianapolis
do_change_locale LANG=en_US.UTF-8
# Don't add any raspi-config configuration options after 'END' line below & don't remove 'END' line
END

# install xinit and Chromium, you can pick your browser but pls don't ask me details for them
sudo apt-get install xinit -y
sudo apt-get install chromium -y
# setup autologin so it acts as a kiosk
sudo mkdir /etc/systemd/system/getty@tty1.service.d/

sudo cat >> /etc/systemd/system/getty@tty1.service.d/override.conf <<END

    [Service]
    Type=simple
    ExecStart=
    ExecStart=-/sbin/agetty --autologin YourUsername --noclear %I 38400 linux
END
# create or modify .profile script in your /home/YopurUsername to start X on login
sudo cat >> .profile <<END

    #Startx Automatically
    if [[ -z "$DISPLAY" ]] && [[ $(tty) = /dev/tty1 ]]; then
        . startx
        logout
    fi
END
# in same location create or edit .xinitrc which will start your browser, eg, Chromium
sudo cat >> .xinitrc <<END

    #!/bin/sh
    xset -dpms
    xset s off
    xset s noblank
    # the following starts Chromium in kiosk/fullscreen and forces FullHD size, disables bunch of toolbars and features etc; modify this or hte Chromium profile to lock it down to your liking, but that's more a question on it's own
    chromium "${defaultUrl}" --window-size=${screenWidth},${screenHeight} --start-fullscreen --kiosk --incognito --noerrdialogs --disable-translate --no-first-run --fast --fast-start --disable-infobars --disable-features=TranslateUI --disk-cache-dir=/dev/null  --password-store=basic
END

# don't allow sudo without password
sudo sed -i /etc/sudoers -re 's/.*NOPASSWD.*/PASSWD/g'

# rotate display on kit stations, but NOT on metrics boards
if [ $screenWidth -lt $screenHeight ]
then
    cat /boot/cmdline.txt >> echo "video=HDMI-A-1:${screenWidth}x${screenHeight}M@60D" > /boot/cmdline.txt
fi

sudo reboot
