#!/bin/bash

if [[ -d "${HOME}/Circuit-Gem" ]]; then
  cd ~/Circuit-Gem
  sudo ./update.sh
elif [[ -d "${HOME}/Circuit-Sword" ]]; then
  cd ~/Circuit-Sword
  sudo ./update.sh
elif [[ -d "${HOME}/Circuit-Sword-Lite" ]]; then
  cd ~/Circuit-Sword-Lite
  sudo ./update.sh
else
  echo "It seems like Kite's CS-HUD software is not installed on your device :("
  echo "Please follow Kite's guides and images to make sure it is installed: https://github.com/kiteretro"
  sleep 10s
fi
