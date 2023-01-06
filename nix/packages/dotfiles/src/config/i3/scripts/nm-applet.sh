#!/usr/bin/env bash

# Add this script to your wm startup file.

# Terminate already running nm-applet instances to prevent duplicates in the the tray
pkill nm-applet || true

# Wait until the processes have been shut down
while pgrep -u $UID nm-applet >/dev/null; do sleep 1; done

# Launch nm-applet from /nix/store
dbus-launch @nm_applet@
