# wayland-pagepi

Simple Digital Signage setup on a Raspberry Pi 4/5 that shows an external web page on the 4k monitor attached.

After running this script is run you will have a kiosk of the web page you entered while running the script. To show the normal Raspbian top taskbar hit Super key aka Windows/Command key and Enter. To hide toolbar Super key and x. 

Copy the content of the 0-waylandpagepi.sh file to a terminal on a newly installed Raspbian Pi and hit Enter. 

Taskbar on / Taskbar off:
Super + Enter / Super + x

By default the page refreshes every 15 minutes. This script is compatible with Raspian Bookworm 64-bit on a Pi 5/4 device. It uses the default Wayland wayfire Windowing setup, Chromium in app mode, Interception tools with hideaway plug (hide mouse), dotool (screen refresh).

