#!/bin/sh
[[ -f $HOME/.shell_colors ]] && rm $HOME/.shell_colors
[[ $(which picom) ]] && pkill picom && nohup picom &>/dev/null & disown
