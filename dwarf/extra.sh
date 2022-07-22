#!/bin/bash

[[ $(which picom) ]] && pkill picom; nohup picom --corner-radius 6 &>/dev/null & disown
