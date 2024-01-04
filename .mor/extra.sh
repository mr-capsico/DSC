#!/bin/bash

[[ $(which picom) ]] && killall picom; picom --shadow-exclude 'class_g != "PLACEHOLDER"' --corner-radius 5 -D 7 &>/dev/null & disown
mv $HOME/.config/rofi/config.rasi $HOME/.config/rofi/config.rasi.inactive
cp ./config.rasi $HOME/.config/rofi/config.rasi
