# Magisk

This folder is for optional Magisk flashable zips used by the LCR tool menu
(`Advanced → Install Magisk (patch boot)`).

## How it works

The recovery ships `/system/bin/lcr-magisk.sh`, which:

1. finds a `Magisk-*.zip` on `/sdcard` (or takes a path as argument), and
2. runs Magisk's own `boot_patch.sh` against the `boot` partition.

From the recovery **Terminal** you can also run it manually:

```
lcr-magisk.sh /sdcard/Magisk-v27.0.zip
```

Put the Magisk zip on internal storage (or SD card) before booting recovery.
No Magisk zip is bundled here (Magisk is GPL-licensed; grab the official one
from https://github.com/topjohnwu/Magisk/releases).
