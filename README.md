# klipper-toolchanger

Based on Viesturz's work on [klipper-toolchanger](https://github.com/viesturz/klipper-toolchanger)

Tool changing extension for [Klipper](https://www.klipper3d.org).

# Klipper Compat Version
- Klipper > Feb 15, 2024 (0cd16e9)
- Danger Klipper > Feb 15, 2024 (0cd16e9)

# Installation

To install this plugin, run the installation script using the following command over SSH. This script will download this GitHub repository to your RaspberryPi home directory, and symlink the files in the Klipper extra folder.

```
wget -O - https://raw.githubusercontent.com/Stealthchanger/klipper-toolchanger/main/install.sh | bash
```

Then, add the following to your moonraker.conf to enable automatic updates:

```
[update_manager klipper-toolchanger]
type: git_repo
primary_branch: main
path: ~/klipper-toolchanger
origin: https://github.com/StealthChanger/klipper-toolchanger.git
managed_services: klipper
```

**Add to `printer.cfg` in this order**
- [toolchanger-tool_detection.cfg](macros/toolchanger-tool_detection.cfg)
- [toolchanger.cfg](macros/toolchanger.cfg)
- [toolchanger-macros.cfg](macros/toolchanger-macros.cfg)
- [toolchanger-homing.cfg](macros/toolchanger-homing.cfg)

**Make sure that `safe_z_home` is not defined as homing needs ot be overriden in [toolchanger-homing.cfg](macros/toolchanger-homing.cfg)**

# Components

* [Multi fan](multi_fan.md) - multiple primary part fans.
* [Toolchanger](toolchanger.md) - tool management support.
* [Tool probe](tool_probe.md) - per tool Z probe.
* [Rounded path](rounded_path.md) - rounds the travel path corners for fast non-print moves.
* [Tools calibrate](tools_calibrate.md) - support for contact based XYZ offset calibration probes.
