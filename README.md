# RetroPie Menu Shortcuts for Kite's Circuit Board

In case you are not familiar with these projects, please visit www.sudomod.com. The AIO (All In One) boards for GameBoy and VMu also come with an excellent HUD software provided by [Kite](https://github.com/kiteretro). There are two functions that require manual intervention in his HUD:
* Enabling/disabling the on-screen baterry monitor.
* Running the HUD update software.

This setup script will update your image and add two RetroPie menu shortcuts to make it easy and simple to access these two features without the need to SSH into the system.

Example of the HUD Update configuration menu item:
![Update Menu](https://github.com/dikodahan/Kite-Circuit-Boards-RPi-Menu-Shurtcuts/blob/master/images/Update-Demo.jpeg "Update Menu on a Circuit-Gem")
For reference info please go to: https://www.sudomod.com/forum/viewtopic.php?f=51&t=7613

Example of the Battery Monitor configuration menu item:
![Battery Menu](https://github.com/dikodahan/Kite-Circuit-Boards-RPi-Menu-Shurtcuts/blob/master/images/Battery-Demo.jpeg "Battery Menu on a Circuit-Gem")
For reference info please go to: https://www.sudomod.com/forum/viewtopic.php?f=51&t=7622

## Running the installer

* SSH into your Circuit board.
* `git clone https://github.com/dikodahan/cs-hud-shortcuts.git`
* `cd cs-hud-shortcuts`
* `chmod +x setup.sh`
* `sudo ./setup.sh`
* once done you will be prompt with a question to reboot your device for the changes to take effect.
* Press `y` if you'd like to reboot immediately or `n` if you'd like to do it later.

## Credits

- Installer script originally built by [Kite](https://github.com/kiteretro) for the Circuit Sword but has been re-purposed to install the menu shurtcuts in RetroPie.
