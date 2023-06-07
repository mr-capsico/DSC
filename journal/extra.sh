#!/bin/bash

[[ $(which picom) ]] && killall picom; picom --shadow-exclude 'class_g != "PLACEHOLDER"' --corner-radius 5 -D 7 &>/dev/null & disown
