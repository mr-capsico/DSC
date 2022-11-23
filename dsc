#!/bin/sh

cd $(dirname "$(readlink -f "$0")") # Move to the directory where the script is
while [ $# -gt 0 ]; do
  arg=$1
  case $arg in
      "activate")
          # Disable any current themes
          if [ "$(find . -name 'reverse')" != "" ]; then
              # find . -name "reverse" | xargs "sh"

	      # Reset ZSH Theme
	      command -v theme
	      [ $? == 0 ] && theme $(grep ZSH_THEME ~/.zshrc | grep -v "#" | sed "s/export //g" | sed "s/ZSH_THEME=//g" | sed "s/\"//g")
          fi
          theme=$2
          cd ./$theme/
          source ./info.sh
	  echo 'cd $(dirname $0); mv $HOME/.gtkrc-2.0.inactive $HOME/.gtkrc-2.0; mv $HOME/.config/gtk-3.0/settings.ini.inactive $HOME/.config/gtk-3.0/settings.ini; mv $HOME/.icons/default/index.theme.inactivate $HOME/.icons/default/index.theme; timeout 0.4s xsettingsd -c ./xsettingsd.conf &> /dev/null; bspc wm -r; bspc config normal_border_color $(bspc config normal_border_color); mv $HOME/.config/alacritty/alacritty.yml.inactive $HOME/.config/alacritty/alacritty.yml; mv $HOME/.config/rofi/config.rasi.inactive $HOME/.config/rofi/config.rasi; pkill polybar; polybar &> /dev/null & sh ~/.fehbg; [ $(head -n1 .zsh_theme | grep "For DSC theme") ] && rm $HOME/.zsh_theme; [ -f ./extra_reverse.sh ] && sh extra_reverse.sh  rm ./reverse' > ./reverse
          chmod +x ./reverse 

          # GTK
          mv $HOME/.gtkrc-2.0 $HOME/.gtkrc-2.0.inactive
          cp ./gtk2 $HOME/.gtkrc-2.0

          mv $HOME/.config/gtk-3.0/settings.ini $HOME/.config/gtk-3.0/settings.ini.inactive
          cp ./gtk3-settings.ini $HOME/.config/gtk-3.0/settings.ini

	  # Mouse Cursor
	  cursor=$(grep "gtk-cursor-theme-name=" ./gtk2 | sed 's/gtk-cursor-theme-name=//g')
	  sed "-i.inactive" "s/Inherits=.*/Inherits=$cursor/g" $HOME/.icons/default/index.theme
          timeout 0.4s xsettingsd -c ./xsettingsd.conf &> /dev/null

	  # ZSH
	  [ -f ./zsh_theme ] && (echo -e "# For DSC theme $theme\n$(cat ./zsh_theme)" > $HOME/.zsh_theme & source ./zsh_theme && clear)

          # BSPWM
          sh ./bspwm_theme.sh




          # Alacritty
          if [ -e $HOME/.config/alacritty/alacritty.yml.inactive ]; then
	      echo "$AR_MSG"
	      exit
          fi
          cp $HOME/.config/alacritty/alacritty.yml $HOME/.config/alacritty/alacritty.yml.inactive
          echo -e "\nimport:\n  - ~/.config/alacritty/lib/$N.yml" > $HOME/.config/alacritty/alacritty.yml 

          # Polybar
          pkill polybar
          polybar --config="./polybar.ini" > /dev/null 2> /dev/null &

          # Rofi
          cp $HOME/.config/rofi/config.rasi $HOME/.config/rofi/config.rasi.inactive
          echo "@theme \"$HOME/.local/share/rofi/themes/$N.rasi\"" >>  $HOME/.config/rofi/config.rasi 


          # Wallpaper
          feh --no-fehbg --bg-scale ./bg.png

          # Extra
	  [ -f ./extra.sh ] && source ./extra.sh

          ;;
      "deactivate")
          if [ "$(find . -name 'reverse')" != "" ]; then
              sh $(find . -name "reverse")
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

