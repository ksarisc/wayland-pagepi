# wayland-pagepi

Simple Digital Signage mode Raspberry Pi 4/5 setup that shows an external web page on the TV attached.

After running this script is run you will have a kiosk of the web page you entered. To show the normal top taskbar hit Super key aka Windows/Command key and Enter. To hide toolbar Super key and x. 

Taskbar on / Taskbar off:
Super + Enter / Super + x

By default the page refreshes every 15 minutes. This script is compatible with Raspian Bookworm 64-bit on a Pi 5/4 device. It uses the default Wayland wayfire Windowing setup, Chromium in app mode, Interception tools with hideaway plug (hide mouse), dotool (screen refresh).

