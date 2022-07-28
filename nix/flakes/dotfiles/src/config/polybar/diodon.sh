#!/usr/bin/env bash

# Add this script to your wm startup file.

DIR="$HOME/.config/diodon/hack"

# Terminate already running diodon instances
killall -q diodon

# Wait until the processes have been shut down
while pgrep -u $UID -x diodon >/dev/null; do sleep 1; done

# Launch diodon
diodon
