#!/bin/bash

cd $(dirname "$(readlink -f "$0")") # Move to the directory where the script is
while [ $# -gt 0 ]; do
  arg=$1
  case $arg in
      "activate")
	      if [[ "$(ls)" != *"$2"* || "$2" == "" ]]; then
		      echo "Error: theme '$2' doesn't exist"
		      exit 1
	      fi
          # Disable any current themes
          if [ "$(find . -name 'reverse')" != "" ]; then
              # find . -name "reverse" | xargs "bash"

	      # Reset ZSH Theme
	      command -v theme
	      [[ $? == 0 ]] && theme $(grep ZSH_THEME ~/.zshrc | grep -v "#" | sed "s/export //g" | sed "s/ZSH_THEME=//g" | sed "s/\"//g")
          fi
          theme=$2
          cd ./$theme/
          source ./info.sh
	  echo 'cd $(dirname $0); mv $HOME/.gtkrc-2.0.inactive $HOME/.gtkrc-2.0; mv $HOME/.config/gtk-3.0/settings.ini.inactive $HOME/.config/gtk-3.0/settings.ini; mv $HOME/.icons/default/index.theme.inactive $HOME/.icons/default/index.theme; timeout 0.4s xsettingsd -c ./xsettingsd.conf &> /dev/null; bspc wm -r; bspc config normal_border_color $(bspc config normal_border_color); mv $HOME/.config/alacritty/alacritty.toml.inactive $HOME/.config/alacritty/alacritty.toml; mv $HOME/.config/rofi/config.rasi.inactive $HOME/.config/rofi/config.rasi; ffdir=$(dirname $(find $HOME/.mozilla/firefox/ -name prefs.js.inactive)); mv $ffdir/prefs.js.inactive $ffdir/prefs.js; killall polybar; polybar &> /dev/null & sh ~/.fehbg; [[ $(head -n1 $HOME/.zsh_theme | grep "For DSC theme") ]] && rm $HOME/.zsh_theme; rm $HOME/.emacs.d/lib/dsc-theme.el; [[ -f ./extra_reverse.sh ]] && sh extra_reverse.sh; rm ./reverse' > ./reverse
          chmod +x ./reverse 

          # GTK
          mv $HOME/.gtkrc-2.0 $HOME/.gtkrc-2.0.inactive
          cp ./gtk2 $HOME/.gtkrc-2.0

          mv $HOME/.config/gtk-3.0/settings.ini $HOME/.config/gtk-3.0/settings.ini.inactive
          cp ./gtk3-settings.ini $HOME/.config/gtk-3.0/settings.ini

	  # Mouse Cursor
	  cursor=$(grep "gtk-cursor-theme-name=" ./gtk2 | sed 's/gtk-cursor-theme-name=//g' | tr -d '"')
	  if [ -e $HOME/.icons/default/index.theme ]; then
	  	sed "-i.inactive" "s/Inherits=.*/Inherits=$cursor/g" $HOME/.icons/default/index.theme
	  else
		echo "Inherits=$cursor" > $HOME/.icons/default/index.theme
	  fi
          timeout 0.4s xsettingsd -c ./xsettingsd.conf &> /dev/null
	  # Mouse Cursor (X Resources)
	  xrdb <(echo "Xcursor.theme: $cursor\nXcursor.size: 16")
	  xsetroot -cursor_name left_ptr # Reloads the cursor when over the desktop

	  # ZSH
	  echo -e "# For DSC theme $theme\n$(cat ./zsh_theme)" > $HOME/.zsh_theme && source $HOME/.zsh_theme && clear

          # BSPWM
          bash ./bspwm_theme.sh




          # Alacritty
          if [ -e $HOME/.config/alacritty/alacritty.toml.inactive ]; then
	      echo "$AR_MSG"
	      exit
          fi
          cp $HOME/.config/alacritty/alacritty.toml $HOME/.config/alacritty/alacritty.toml.inactive
	  echo -e "\nimport = [\"/home/desot/.config/alacritty/lib/$N.toml\"]" > $HOME/.config/alacritty/alacritty.toml

          # Polybar
          pkill polybar
          polybar --config="./polybar.ini" > /dev/null 2> /dev/null &

          # Rofi
          cp $HOME/.config/rofi/config.rasi $HOME/.config/rofi/config.rasi.inactive
          if [[ -f "./config.rasi" ]]; then
              cp ./config.rasi $HOME/.config/rofi/config.rasi
          else
              echo "@theme \"$HOME/.local/share/rofi/themes/$N.rasi\"" >  $HOME/.config/rofi/config.rasi 
          fi

	  # Firefox (Experimental)
#	  profile=$(cat ~/.mozilla/firefox/profiles.ini | grep 'Default=' | head -n1 | sed 's/Default=//g') # For Firefox
#	  if [[ -e ./firefox-prefs.js ]]; then
#	  	mv $HOME/.mozilla/firefox/$profile/prefs.js $HOME/.mozilla/firefox/$profile/prefs.js.inactive
#	  	cp ./firefox-prefs.js $HOME/.mozilla/firefox/$profile/prefs.js
#	  fi
#	  if [[ -e ./firefox-user.js ]]; then
#	  	mv $HOME/.mozilla/firefox/$profile/user.js $HOME/.mozilla/firefox/$profile/user.js.inactive
#	  	cp ./firefox-user.js $HOME/.mozilla/firefox/$profile/user.js
#	  fi
#	  if [[ -d ./firefox-chrome/ ]]; then
#	  	mv $HOME/.mozilla/firefox/$profile/chrome/ $HOME/.mozilla/firefox/$profile/chrome.inactive
#	  	cp ./firefox-chrome/ $HOME/.mozilla/firefox/$profile/chrome
#	  fi


          # Wallpaper
          feh --no-fehbg --bg-scale ./bg.png

          # Extra
	  [[ -f ./extra.sh ]] && source ./extra.sh

          # Extra
	  [[ -f ./dsc-theme.el ]] && cp ./dsc-theme.el $HOME/.emacs.d/lib/dsc-theme.el

          ;;
      "deactivate")
          if [ "$(find . -name 'reverse')" != "" ]; then
              bash $(find . -name "reverse")
          fi
          ;;
      "status")
          if [ "$(find . -name 'reverse')" != "" ]; then
              echo "Status: Active"
	      source $(dirname $(find . -name 'reverse'))/info.sh
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

