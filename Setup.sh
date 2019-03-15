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

GITLABPROJECT="Kite-Circuit-Boards-RPi-Menu-Shurtcuts"
GITLABURL="https://github.com/dikodahan/$GITLABPROJECT"
PIHOMEDIR="/home/pi"
BINDIR="$PIHOMEDIR/$GITLABPROJECT"
USER="pi"

#####################################################################
# Functions
execute() { #STRING
  if [ $# != 1 ] ; then
    echo "ERROR: No args passed"
    exit 1
  fi
  cmd=$1

  echo "[*] EXECUTE: [$cmd]"
  eval "$cmd"
  ret=$?

  if [ $ret != 0 ] ; then
    echo "ERROR: Command exited with [$ret]"
    exit 1
  fi

  return 0
}

exists() { #FILE
  if [ $# != 1 ] ; then
    echo "ERROR: No args passed"
    exit 1
  fi

  file=$1

  if [ -f $file ]; then
    echo "[i] FILE: [$file] exists."
    return 0
  else
    echo "[i] FILE: [$file] does not exist."
    return 1
  fi
}

#####################################################################
# LOGIC!
echo "INSTALLING.."

# Checkout code if not already done so
if ! exists "$BINDIR/LICENSE" ; then
    execute "git clone --recursive --depth 1 --branch $BRANCH $GITLABURL $BINDIR"
fi
execute "chown -R $USER:$USER $BINDIR"

if ! exists "$DESTBOOT/config_ORIGINAL.txt" ; then
    echo "Copying optimized config.txt:"
    execute "cp $DESTBOOT/config.txt $DESTBOOT/config_ORIGINAL.txt"
    execute "cp $BINDIR/settings/config.txt $DESTBOOT/config.txt"
fi

# Copy splashscreens
if ! exists "$PIHOMEDIR/RetroPie/splashscreens/GBZ-Splash-Screen.mp4" ; then
    echo "Copying splashscreen:"
    execute "cp $BINDIR/splashscreens/GBZ-Splash-Screen.mp4 $PIHOMEDIR/RetroPie/splashscreens/GBZ-Splash-Screen.mp4"
    if exists "$DEST/etc/splashscreen.list" ; then
      echo "Setting default splashscreen default:"
      execute "sed -i 's|$DEST/opt/retropie/supplementary/splashscreen/retropie-default.png|$PIHOMEDIR/RetroPie/splashscreens/GBZ-Splash-Screen.mp4|' $DEST/etc/splashscreen.list"
    fi
fi

# Fix splashsreen sound
if exists "$DEST/etc/init.d/asplashscreen" ; then
    execute "sed -i \"s/ *both/ alsa/\" $DEST/etc/init.d/asplashscreen"
fi
if exists "$DEST/opt/retropie/supplementary/splashscreen/asplashscreen.sh" ; then
    execute "sed -i \"s/ *both/ alsa/\" $DEST/opt/retropie/supplementary/splashscreen/asplashscreen.sh"
fi

# Install the gbz35 theme and set it as default
if ! exists "$DEST/etc/emulationstation/themes/gbz35/gbz35.xml" ; then
    echo "Installing theme for 3.5\" screens:"
    execute "mkdir -p $DEST/etc/emulationstation/themes"
    execute "rm -rf $DEST/etc/emulationstation/themes/gbz35"
    execute "git clone --recursive --depth 1 --branch master https://github.com/rxbrad/es-theme-gbz35.git $DEST/etc/emulationstation/themes/gbz35"
    execute "cp $BINDIR/settings/es_settings.cfg $DEST/opt/retropie/configs/all/emulationstation/es_settings.cfg"
    execute "sed -i \"s/carbon/gbz35/\" $DEST/opt/retropie/configs/all/emulationstation/es_settings.cfg"
    execute "chown $USER:$USER $DEST/opt/retropie/configs/all/emulationstation/es_settings.cfg"
fi

# Install the gbz35-dark theme
if ! exists "$DEST/etc/emulationstation/themes/gbz35-dark/gbz35.xml" ; then
    execute "mkdir -p $DEST/etc/emulationstation/themes"
    execute "rm -rf $DEST/etc/emulationstation/themes/gbz35-dark"
    execute "git clone --recursive --depth 1 --branch master https://github.com/rxbrad/es-theme-gbz35-dark.git $DEST/etc/emulationstation/themes/gbz35-dark"
fi

# Disable fsck
# https://www.sudomod.com/forum/viewtopic.php?f=44&t=6292#p63567
if exists "$DEST/opt/retropie/supplementary/splashscreen/asplashscreen.sh" ; then
    echo "Disabling fsck on boot:"
    execute "sed -i 's|defaults          0       2|defaults          0       0|' $DEST/etc/.fstab"
    execute "sed -i 's|defaults,noatime  0       1|defaults,noatime  0       0|' $DEST/etc/.fstab"
    execute "sed -i 's|defaults          0       2|defaults          0       0|' $DEST/etc/fstab"
    execute "sed -i 's|defaults,noatime  0       1|defaults,noatime  0       0|' $DEST/etc/fstab"
fi

# Disable 'wait for network' on boot
echo "Disabling 'wait for network' on boot:"
execute "rm -f $DEST/etc/systemd/system/dhcpcd.service.d/wait.conf"

# Disable fast forward when Select is pressed
execute "echo 'input_toggle_fast_forward_btn = nul' >> $DEST/opt/retropie/configs/all/retroarch.cfg"

# Change to home directory
execute "cd $PIHOMEDIR"

# Install Retrogame
execute "curl https://raw.githubusercontent.com/adafruit/Raspberry-Pi-Installer-Scripts/master/retrogame.sh >retrogame.sh"
execute "bash retrogame.sh"
execute "cp $BINDIR/settings/retrogame.cfg $DESTBOOT/retrogame.cfg"

# Install battery monitor
execute "wget https://gitlab.com/sixteenbitsystems/gbz-combo-script/raw/master/InstallComboScript.sh"
execute "git clone https://gitlab.com/sixteenbitsystems/gbz-combo-script.git"
execute "chmod +x InstallComboScript.sh"
execute "./InstallComboScript.sh"

# Install i2s script
execute "curl -sS https://raw.githubusercontent.com/adafruit/Raspberry-Pi-Installer-Scripts/master/i2samp.sh | bash"

#####################################################################
# DONE
echo "DONE!"