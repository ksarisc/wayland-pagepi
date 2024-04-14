# wayland-pagepi

Simple Digital Signage setup on a Raspberry Pi 4/5 that shows an external web page on the 4k monitor attached.

After running this script is run you will have a kiosk of the web page you entered while running the script. To show the normal Raspbery Pi OS top taskbar hit Super key aka Windows/Command key and Enter. To hide toolbar hit Super key and x. 

Copy the content of the 0-waylandpagepi.sh file to a terminal on a newly installed Raspbery Pi OS and hit Enter. 

Taskbar on / Taskbar off:
Super + Enter / Super + x

By default a cronjob forces a page refresh every 15 minutes. This script is compatible with Raspberry Pi OS Bookworm 64-bit on a Pi 5/4 device. It uses the default Wayland Wayfire windowing setup, Chromium in app mode, Interception-tools with Hideaway plug (hide mouse), dotool (screen refresh).

Youtube How To:
https://youtu.be/qzZgLe_uIjg

