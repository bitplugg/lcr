# Magisk

Magisk is **bundled inside the LCR recovery ramdisk** ("LCR memory"), so you do
not need an SD card or to download anything.

At build time CI downloads the latest official Magisk package and places it at
`/system/etc/lcr/Magisk.apk` inside the recovery image. The recovery tool
`Advanced → Install Magisk (patch boot)` (or `lcr-magisk.sh` in the terminal)
runs Magisk's own `boot_patch.sh` against the `boot` partition.

Manual use from the recovery **Terminal**:

```
lcr-magisk.sh                          # use the bundled Magisk
lcr-magisk.sh /sdcard/Magisk-v27.0.apk # use your own package
```

The bundled package is fetched from https://github.com/topjohnwu/Magisk/releases
(Magisk is GPL-3.0). A user-supplied package on `/sdcard` always takes priority.
