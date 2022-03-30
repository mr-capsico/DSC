#!/bin/bash

cd $(dirname "$(readlink -f "$0")") # Move to the directory where the script is
while [ $# -gt 0 ]; do
  arg=$1
  case $arg in
      "activate")
          # Disable any current themes
          if [ "$(find . -name 'reverse')" != "" ]; then
              bash $(find . -name "reverse")
          fi
          theme=$2
          cd ./$theme/
          source ./info.sh

          echo 'cd $(dirname $0); mv $HOME/.gtkrc-2.0.inactive $HOME/.gtkrc-2.0; mv $HOME/.config/gtk-3.0/settings.ini.inactive $HOME/.config/gtk-3.0/settings.ini; timeout 0.4s xsettingsd -c ./xsettingsd.conf &> /dev/null; bspc wm -r; bspc config normal_border_color $(bspc config normal_border_color); mv $HOME/.config/alacritty/alacritty.yml.inactive $HOME/.config/alacritty/alacritty.yml; mv $HOME/.config/rofi/config.rasi.inactive $HOME/.config/rofi/config.rasi; killall polybar; polybar &> /dev/null & bash ~/.fehbg; rm ./reverse' > ./reverse
          chmod +x ./reverse 

          # BSPWM
          bash ./bspwm_theme.sh

          # GTK
          mv $HOME/.gtkrc-2.0 $HOME/.gtkrc-2.0.inactive
          cp ./gtk2 $HOME/.gtkrc-2.0

          mv $HOME/.config/gtk-3.0/settings.ini $HOME/.config/gtk-3.0/settings.ini.inactive
          cp ./gtk3-settings.ini $HOME/.config/gtk-3.0/settings.ini
          timeout 0.4s xsettingsd -c ./xsettingsd.conf &> /dev/null


          # Alacritty
          if [ -e $HOME/.config/alacritty/alacritty.yml.inactive ]; then
	      echo "$AR_MSG"
	      exit
          fi
          cp $HOME/.config/alacritty/alacritty.yml $HOME/.config/alacritty/alacritty.yml.inactive
          echo -e "\nimport:\n  - ~/.config/alacritty/lib/$N.yml" >> $HOME/.config/alacritty/alacritty.yml 

          # Polybar
          killall polybar
          polybar --config="./polybar.ini" > /dev/null 2> /dev/null &

          # Rofi
          cp $HOME/.config/rofi/config.rasi $HOME/.config/rofi/config.rasi.inactive
          echo "@theme \"$HOME/.local/share/rofi/themes/$N.rasi\"" >>  $HOME/.config/rofi/config.rasi 


          # Wallpaper
          feh --no-fehbg --bg-scale ./bg.png

          
          ;;
      "deactivate")
          if [ "$(find . -name 'reverse')" != "" ]; then
              bash $(find . -name "reverse")
          fi
          ;;
      "status")
          if [ "$(find . -name 'reverse')" != "" ]; then
              echo "Status: Active"
              source $(find . -name "reverse" | sed "s/reverse//")info.sh
              echo "Current: $title"
          else
              echo "Status: Inactive"
          fi
          ;;
      "list")
          grep "title=" */info.sh | sed "s/title=//; s/\"//g; s/\/info.sh//; s/:/ - /"
          ;;
    help)
      echo activate deactivate status list help
    ;;
    *)
     # echo Invalid option
    ;;
  esac
  shift
done

