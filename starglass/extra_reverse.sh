#!/bin/sh
[[ $(which picom) ]] && pkill picom && nohup picom &>/dev/null & disown
[[ -f $HOME/.shell_colors ]] && rm $HOME/.shell_colors && exit
