#!/bin/bash

bspc config top_padding 0 && bspc wm -r && sleep 0.5

[[ $(which picom) ]] && killall picom
picom --shadow-exclude 'class_g != "PLACEHOLDER"' --corner-radius 25 &>/dev/null & disown
