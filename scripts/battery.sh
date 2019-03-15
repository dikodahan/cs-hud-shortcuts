#! /bin/sh

sudo systemctl stop cs-hud.service

if [[ -d "${HOME}/Circuit-Gem" ]]; then
  if grep -q "ExecStart=/home/pi/Circuit-Gem/cs-hud/cs-hud -s" "/lib/systemd/system/cs-hud.service"; then
    sudo sed -i 's/ExecStart=\/home\/pi\/Circuit-Gem\/cs-hud\/cs-hud -s/ExecStart=\/home\/pi\/Circuit-Gem\/cs-hud\/cs-hud/g' /lib/systemd/system/cs-hud.service
  else
    sudo sed -i 's/ExecStart=\/home\/pi\/Circuit-Gem\/cs-hud\/cs-hud/ExecStart=\/home\/pi\/Circuit-Gem\/cs-hud\/cs-hud -s/g' /lib/systemd/system/cs-hud.service
  fi
elif [[ -d "${HOME}/Circuit-Sword" ]]; then
  if grep -q "ExecStart=/home/pi/Circuit-Sword/cs-hud/cs-hud -s" "/lib/systemd/system/cs-hud.service"; then
    sudo sed -i 's/ExecStart=\/home\/pi\/Circuit-Sword\/cs-hud\/cs-hud -s/ExecStart=\/home\/pi\/Circuit-Sword\/cs-hud\/cs-hud/g' /lib/systemd/system/cs-hud.service
  else
    sudo sed -i 's/ExecStart=\/home\/pi\/Circuit-Sword\/cs-hud\/cs-hud/ExecStart=\/home\/pi\/Circuit-Sword\/cs-hud\/cs-hud -s/g' /lib/systemd/system/cs-hud.service
  fi
elif [[ -d "${HOME}/Circuit-Sword-Lite" ]]; then
  if grep -q "ExecStart=/home/pi/Circuit-Sword-Lite/cs-hud/cs-hud -s" "/lib/systemd/system/cs-hud.service"; then
    sudo sed -i 's/ExecStart=\/home\/pi\/Circuit-Sword-Lite\/cs-hud\/cs-hud -s/ExecStart=\/home\/pi\/Circuit-Sword-Lite\/cs-hud\/cs-hud/g' /lib/systemd/system/cs-hud.ser$
  else
    sudo sed -i 's/ExecStart=\/home\/pi\/Circuit-Sword-Lite\/cs-hud\/cs-hud/ExecStart=\/home\/pi\/Circuit-Sword-Lite\/cs-hud\/cs-hud -s/g' /lib/systemd/system/cs-hud.ser$
  fi
else
  echo "It seems like Kite's CS-HUD software is not installed on your device :("
  echo "Please follow Kite's guides and images to make sure it is installed: https://github.com/kiteretro"
  sleep 10s
fi

sudo systemctl daemon-reload
sudo systemctl start cs-hud.service
