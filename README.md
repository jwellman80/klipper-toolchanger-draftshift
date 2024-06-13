# WIP NOT FOR USE

# klipper-toolchanger

Based on Viesturz's work on [klipper-toolchanger](https://github.com/viesturz/klipper-toolchanger)

Tool changing extension for [Klipper](https://www.klipper3d.org).

# Klipper Compat Version
- Klipper > Feb 15, 2024 (0cd16e9)
- Danger Klipper > Feb 15, 2024 (0cd16e9)

# Installation

**NOTE:** `python 3.9+` is required for this mod, make sure your klipper install is using `python 3.9+`, otherwise you need to reinstall klipper with `python 3.9+` before you continue

To install this plugin, run the installation script using the following command over SSH. This script will download this GitHub repository to your RaspberryPi home directory, and symlink the files in the Klipper extra folder.

```
wget -O - https://raw.githubusercontent.com/Stealthchanger/klipper-toolchanger/main/scripts/install.sh | bash
```

**Add to `printer.cfg` in this order**
- [toolchanger-tool_detection.cfg](macros/toolchanger-tool_detection.cfg)
- [toolchanger.cfg](examples/toolchanger.cfg)
- [toolchanger-macros.cfg](macros/toolchanger-macros.cfg)
- [toolchanger-homing.cfg](macros/toolchanger-homing.cfg)

**Optional** these files are a good start for user macros and can be modified.  Make sure to keep the `_TOOL` and `_TOOLCHANGER` macros in the right macros as they add special features.
- [toolchanger-usermacros.cfg](examples/toolchanger-usermacros.cfg)
- [toolchanger-extra-macro-examples.cfg](examples/toolchanger-extra-macro-examples.cfg)
- [calibrate-offsets.cfg](examples/calibrate-offsets.cfg)
- [calibrate-offsets-macros.cfg](macros/calibrate-offsets-macros.cfg)

[PRINT_START slicer info](PRINT_START.md)

**Make sure that `safe_z_home` is not defined as homing needs to be overridden in [toolchanger-homing.cfg](macros/toolchanger-homing.cfg)**

**If you choose to not use `toolchanger-extra-macro-examples.cfg` please make sure to use the `_TOOLCHANGER_PRINT_START_START` and `_TOOLCHANGER_PRINT_START_END` in your `PRINT_START` macro, also `_TOOLCHANGER_PRINT_END_START` and `_TOOLCHANGER_PRINT_END_END` in your `PRINT_END` macro.  These are important to initialize the toolchanger as well as special protection calls.**

# Components

* ~~[Multi fan](multi_fan.md) - multiple primary part fans.~~ **OBSOLETE**
* [Toolchanger](toolchanger.md) - tool management support.
* [Tool probe](tool_probe.md) - per tool Z probe.
* [Rounded path](rounded_path.md) - rounds the travel path corners for fast non-print moves.
* [Tools calibrate](tools_calibrate.md) - support for contact based XYZ offset calibration probes.
