#!/bin/sh

(cat ./shell_colors)
ln ./shell_colors $HOME/.shell_colors
[[ $(which picom) ]] && (pkill picom; nohup picom -f -D 3 &> /dev/null & disown)
source $HOME/.zsh_theme
