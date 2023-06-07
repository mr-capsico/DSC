#!/bin/sh

[[ $(which picom) ]] && (pkill picom; nohup picom &> /dev/null & disown)
