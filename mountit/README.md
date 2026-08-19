# Mount It — Home Assistant Addon

![Mount It](https://raw.githubusercontent.com/EnderDragonEP/HomeAssistant-Apps/main/.asset/mountit/banner.png)

Automatically detects and mounts external USB/SATA drives. You can expose them as Home Assistant network storage via the Supervisor Mounts API, or keep them mounted only inside the add-on.

Icon & banner is made in [draw.io](https://github.com/jgraph/drawio)

![Supports aarch64 Architecture][aarch64-shield]
![Supports amd64 Architecture][amd64-shield]
![Supports armv7 Architecture][armv7-shield]

## Features

- Auto-detects labeled drives on startup and hot-plug
- Optional HA network storage exposure in **Settings → Storage**
- Optional support for unlabeled drives
- Configurable storage location (`media`, `share`, or `backup`)
- Advanced folder mapping: expose subfolders to different HA locations
- HDD idle power-down support
- Configurable file activity logging for troubleshooting
- Clean shutdown: deregisters mounts and unmounts drives

## Supported filesystems

ext2/3/4, NTFS, Btrfs, XFS, exFAT/FAT32, APFS (read-only)

## Installation

1. Add this repository to your HA addon store
2. Install **Mount It**
3. Disable **Protection Mode** in the addon settings
4. Start the addon

## Documentation

See [DOCS.md](DOCS.md) for full configuration reference.

Set `expose_network_storage` to `false` if you want Mount It to mount drives directly under `/media`, `/share`, or `/backup` based on `mount_location`, without starting Samba or creating Home Assistant network storage entries.

[aarch64-shield]: https://img.shields.io/badge/aarch64-yes-green.svg
[amd64-shield]: https://img.shields.io/badge/amd64-yes-green.svg
[armv7-shield]: https://img.shields.io/badge/armv7-yes-green.svg
