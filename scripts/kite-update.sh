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
fi
