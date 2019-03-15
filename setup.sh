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
    echo "Copying battery indicator script"
    cp $BINDIR/scripts/battery.sh $PIHOMEDIR/RetroPie/retropiemenu
    chmod +x $PIHOMEDIR/RetroPie/retropiemenu/battery.sh
    echo "Copying battery icon"
    cp $BINDIR/images/battery.png $PIHOMEDIR/RetroPie/retropiemenu/icons
    if grep -Fxq "battery.sh" /opt/retropie/configs/all/emulationstation/gamelists/retropie/gamelist.xml; then
      echo "Adding battery indicator menu item to RetroPie"
      sed -i '$ i\        <game\>' /opt/retropie/configs/all/emulationstation/gamelists/retropie/gamelist.xml
      sed -i '$ i\                <path\>.\/battery.sh\<\/path\>' /opt/retropie/configs/all/emulationstation/gamelists/retropie/gamelist.xml
      sed -i '$ i\                <name\>Battery Indicator\<\/name\>' /opt/retropie/configs/all/emulationstation/gamelists/retropie/gamelist.xml
      sed -i '$ i\                <desc\>Turns ON and OFF the battery indicator in Kite\'s HUD software.\<\/desc\>' /opt/retropie/configs/all/emulationstation/gamelists/retropie/gamelist.xml
      sed -i '$ i\                <image\>.\/icons\/battery.png\<\/image\>' /opt/retropie/configs/all/emulationstation/gamelists/retropie/gamelist.xml
      sed -i '$ i\        <\/game\>' /opt/retropie/configs/all/emulationstation/gamelists/retropie/gamelist.xml
    fi
fi

# Set up Kite's HUD Update script and icon in RetroPie
if [ ! -f "$PIHOMEDIR/RetroPie/retromenu/kite-update.sh" ]; then
    echo "Copying HUD Update script"
    cp $BINDIR/scripts/kite-update.sh $PIHOMEDIR/RetroPie/retropiemenu
    chmod +x $PIHOMEDIR/RetroPie/retropiemenu/kite-update.sh
    echo "Copying HUD Update icon"
    cp $BINDIR/images/kite.png $PIHOMEDIR/RetroPie/retropiemenu/icons
    if grep -Fxq "kite-update.sh" /opt/retropie/configs/all/emulationstation/gamelists/retropie/gamelist.xml; then
      echo "Adding Kite's HUD update menu item to RetroPie"
      sed -i '$ i\        <game\>' /opt/retropie/configs/all/emulationstation/gamelists/retropie/gamelist.xml
      sed -i '$ i\                <path\>.\/kite-update.sh\<\/path\>' /opt/retropie/configs/all/emulationstation/gamelists/retropie/gamelist.xml
      sed -i '$ i\                <name\>Kite HUD Update\<\/name\>' /opt/retropie/configs/all/emulationstation/gamelists/retropie/gamelist.xml
      sed -i '$ i\                <desc\>Installs available updates to Kite\'s HUD software.\<\/desc\>' /opt/retropie/configs/all/emulationstation/gamelists/retropie/gamelist.xml
      sed -i '$ i\                <image\>.\/icons\/kite.png\<\/image\>' /opt/retropie/configs/all/emulationstation/gamelists/retropie/gamelist.xml
      sed -i '$ i\        <\/game\>' /opt/retropie/configs/all/emulationstation/gamelists/retropie/gamelist.xml
    fi
fi

#####################################################################
# DONE
echo " "
echo "DONE!"
echo "You need to reboot your device in order for these changes to take effect."
