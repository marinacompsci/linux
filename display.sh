#!/usr/bin/env bash

xrandr --newmode "1712x1112_60.00" 158.25 1712 1824 2000 2288 1112 1115 1125 1154 -hsync +vsync 2>&1 | logger -t i3-xrandr
sleep 2 && xrandr --addmode Virtual-1 1712x1112_60.00 2>&1 | logger -t i3-xrandr
sleep 2 && xrandr --output Virtual-1 --mode 1712x1112_60.00 2>&1 | logger -t i3-xrandr
