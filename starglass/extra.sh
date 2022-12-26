#!/bin/bash

(cat ./shell_colors)
ln ./shell_colors $HOME/.shell_colors
[ $(which picom) ] && (killall picom; nohup picom -f -D 3 -o 0 &> /dev/null & disown)
source $HOME/.zsh_theme
