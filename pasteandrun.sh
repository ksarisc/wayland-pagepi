#!/bin/bash
# hide mouse in wayland raspbian
# Ask the user for info
read -p 'What is the website url you want to display? ' webvar
echo Website you want to display on TV? $webvar
while true; do
    read -p "Is the above info correct? " yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done
echo continuing

sudo apt install -y interception-tools interception-tools-compat

sudo apt install -y cmake
cd ~
git clone https://gitlab.com/interception/linux/plugins/hideaway.git
cd hideaway
cmake -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build
sudo cp /home/user/hideaway/build/hideaway /usr/bin
sudo chmod +x /usr/bin/hideaway

cd ~
wget https://raw.githubusercontent.com/ugotapi/wayland-pagepi/main/config.yaml
sudo cp /home/$USER/config.yaml /etc/interception/udevmon.d/config.yaml
sudo systemctl restart udevmon

#create the file that starts Chromium a displays a web page. myscript.sh is what you edit to get a different web page on the TV. 
cat > /home/$USER/myscript.sh << EOL
#!/bin/sh
# what this script does: start chromium
chromium-browser --start-maximized  --incognito --user-data-dir=/home/$USER/.config/chromium2 --enable-features=OverlayScrollbar,OverlayScrollbarFlashAfterAnyScrollUpdate,OverlayScrollbarFlashWhenMouseEnter --app=$webvar &
EOL

sudo chmod +x /home/$USER/myscript.sh

# disable topbar start in wayfire
file_path="/etc/wayfire/defaults.ini"
target_line="autostart0 = wfrespawn wf-panel-pi"

# Use sed to find and modify the line
sudo sed -i "s/^$target_line/# $target_line/" "$file_path"

#PIPING THIS INTO WAYFIRE.INI
#to see top bar hit super key and Enter to kill superkey and x
# binding_show_taskbar=<super> KEY_ENTER
#command_show_taskbar=wf-panel-pi
#binding_hide_taskbar=<super> KEY_X
#command_hide_taskbar=sudo pkill wf-panel-pi

# File path
file_path="/home/$USER/.config/wayfire.ini"

# Target line to append after
target_line="command_power = pwrkey"

# Use sed to append the lines after the target line
sed -i "/$target_line/a\binding_show_taskbar=<super> KEY_ENTER\ncommand_show_taskbar=wf-panel-pi\nbinding_hide_taskbar=<super> KEY_X\ncommand_hide_taskbar=sudo pkill wf-panel-pi" "$file_path"

# File path
file_path="/etc/wayfire/defaults.ini"

# Text string to remove
text_to_remove="pixdecor"

# Use sed to remove the text string
sudo sed -i "s/$text_to_remove//g" "$file_path"

# File path
file_path="/home/$USER/.config/wayfire.ini"

# Text string to add
text_to_add="
[autostart]
runmeman = $HOME/myscript.sh
"

# Check if the [autostart] section already exists
if grep -q "^\[autostart\]" "$file_path"; then
    # Append the text after the last line of the [autostart] section
    sed -i "/^\[autostart\]/,$ a\
$text_to_add" "$file_path"
else
    # Append the text to the end of the file
    echo -e "$text_to_add" >> "$file_path"
fi

sudo apt install -y golang libxkbcommon-dev scdoc
cd ~
wget https://git.sr.ht/~geb/dotool/archive/b5812c001daeeaff1f259031661e47f3a612220c.tar.gz
tar -xf b5812c001daeeaff1f259031661e47f3a612220c.tar.gz
cd dotool-b5812c001daeeaff1f259031661e47f3a612220c
./build.sh && sudo ./build.sh install
sudo udevadm control --reload && sudo udevadm trigger

echo '#!/bin/sh' > /home/$USER/refresh.sh 
echo 'echo key ctrl+k:63 | /usr/local/bin/dotool' >> /home/$USER/refresh.sh 

# make executable
sudo chmod +x /home/$USER/refresh.sh 

cd ~
# refresh every 15 minutes
#write out current crontab
crontab -l > mycron
#echo new cron into cron file
echo "*/15 * * * * DISPLAY=:0 /home/$USER/refresh.sh" >> mycron
#install new cron file
crontab mycron
rm mycron


read -p "After this reboot your website should display. To edit the website displayed edit: the file here /home/$USER/myscript.sh  Hit Enter key to continue"

sudo reboot

























