#!/usr/bin/env bash

xrandr --newmode  2>&1 | logger -t i3-xrandr
sleep 1 && xrandr --addmode Virtual-1  2>&1 | logger -t i3-xrandr
sleep 1 && xrandr --output Virtual-1 --mode  2>&1 | logger -t i3-xrandr
