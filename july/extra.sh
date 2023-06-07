#!/bin/sh

[[ $(which picom) ]] && (pkill picom; nohup picom --corner-radius 3 &> /dev/null & disown)
