#!/bin/bash

#
# Author: Moshe Dahan
#
# THIS HEADER MUST REMAIN WITH THIS FILE AT ALL TIMES
#
# This firmware is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This firmware is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this repo. If not, see <http://www.gnu.org/licenses/>.
#

if [ "$EUID" -ne 0 ]
  then echo "Please run as root (sudo)"
  exit 1
fi

#####################################################################
# Vars

GITHUBPROJECT="cs-hud-shortcuts"
GITHUBURL="https://github.com/dikodahan/$GITHUBPROJECT"
PIHOMEDIR="/home/pi"
BINDIR="$PIHOMEDIR/$GITHUBPROJECT"
USER="pi"

#####################################################################
# LOGIC!
echo "INSTALLING.."

# Checkout code if not already done so
if [ ! -f "$BINDIR/LICENSE" ]; then
    git clone --recursive --depth 1 --branch master $GITHUBURL $BINDIR
fi
chown -R $USER:$USER $BINDIR

# Set up Battery Indicator script and icon in RetroPie
if [ ! -f "$PIHOMEDIR/RetroPie/retromenu/battery.sh" ]; then
    echo -ne "Copying battery indicator script...\r"
    cp $BINDIR/scripts/battery.sh $PIHOMEDIR/RetroPie/retropiemenu
    chmod +x $PIHOMEDIR/RetroPie/retropiemenu/battery.sh
    echo -ne "Copying battery indicator script...DONE\r"
    echo -ne "\n"
    echo -ne "Copying battery icon...\r"
    cp $BINDIR/images/battery.png $PIHOMEDIR/RetroPie/retropiemenu/icons
    echo -ne "Copying battery icon...DONE\r"
    echo -ne "\n"
    if grep -Fxq "battery.sh" /opt/retropie/configs/all/emulationstation/gamelists/retropie/gamelist.xml; then
      echo -ne "Adding battery indicator menu item to RetroPie...\r"
      sed -i '$ i\        <game\>' /opt/retropie/configs/all/emulationstation/gamelists/retropie/gamelist.xml
      sed -i '$ i\                <path\>.\/battery.sh\<\/path\>' /opt/retropie/configs/all/emulationstation/gamelists/retropie/gamelist.xml
      sed -i '$ i\                <name\>Battery Indicator\<\/name\>' /opt/retropie/configs/all/emulationstation/gamelists/retropie/gamelist.xml
      sed -i '$ i\                <desc\>Turns ON and OFF the battery indicator in Kite HUD software.\<\/desc\>' /opt/retropie/configs/all/emulationstation/gamelists/retropie/gamelist.xml
      sed -i '$ i\                <image\>.\/icons\/battery.png\<\/image\>' /opt/retropie/configs/all/emulationstation/gamelists/retropie/gamelist.xml
      sed -i '$ i\        <\/game\>' /opt/retropie/configs/all/emulationstation/gamelists/retropie/gamelist.xml
      echo -ne "Adding battery indicator menu item to RetroPie...DONE\r"
      echo -ne "\n"
    fi
fi

# Set up Kite's HUD Update script and icon in RetroPie
if [ ! -f "$PIHOMEDIR/RetroPie/retromenu/kite-update.sh" ]; then
    echo -ne "Copying HUD Update script...\r"
    cp $BINDIR/scripts/kite-update.sh $PIHOMEDIR/RetroPie/retropiemenu
    chmod +x $PIHOMEDIR/RetroPie/retropiemenu/kite-update.sh
    echo -ne "Copying HUD Update script...DONE\r"
    echo -ne "\n"
    echo -ne "Copying HUD Update icon...\r"
    cp $BINDIR/images/kite.png $PIHOMEDIR/RetroPie/retropiemenu/icons
    echo -ne "Copying HUD Update icon...DONE\r"
    echo -ne "\n"
    if grep -Fxq "kite-update.sh" /opt/retropie/configs/all/emulationstation/gamelists/retropie/gamelist.xml; then
      echo -ne "Adding Kite's HUD update menu item to RetroPie...\r"
      sed -i '$ i\        <game\>' /opt/retropie/configs/all/emulationstation/gamelists/retropie/gamelist.xml
      sed -i '$ i\                <path\>.\/kite-update.sh\<\/path\>' /opt/retropie/configs/all/emulationstation/gamelists/retropie/gamelist.xml
      sed -i '$ i\                <name\>Kite HUD Update\<\/name\>' /opt/retropie/configs/all/emulationstation/gamelists/retropie/gamelist.xml
      sed -i '$ i\                <desc\>Installs available updates to Kite HUD software.\<\/desc\>' /opt/retropie/configs/all/emulationstation/gamelists/retropie/gamelist.xml
      sed -i '$ i\                <image\>.\/icons\/kite.png\<\/image\>' /opt/retropie/configs/all/emulationstation/gamelists/retropie/gamelist.xml
      sed -i '$ i\        <\/game\>' /opt/retropie/configs/all/emulationstation/gamelists/retropie/gamelist.xml
      echo -ne "Adding Kite's HUD update menu item to RetroPie...DONE\r"
      echo -ne "\n"
    fi
fi

#####################################################################
# DONE
echo ""
echo "DONE!"
read -p "Would you like to reboot your device now for the changes to take effect[Y/n]? " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
  echo ""
  echo "Rebooting..."
  sleep 3s
  reboot
else
  echo ""
  echo "These changes will take effect next time you reboot your device."
fi
