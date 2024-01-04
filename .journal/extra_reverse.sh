#!/bin/bash
[[ $(which picom) ]] && pkill picom; nohup picom &>/dev/null & disown
