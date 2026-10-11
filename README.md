# LCR — Lavender Custom Recovery

Custom [TWRP](https://twrp.me)-based recovery for the **Xiaomi Redmi Note 7**
(`lavender`) and **Redmi Note 7S** (`lavenderin`).

- **Base:** TWRP `twrp-14.1` (Android 14 minimal manifest)
- **Branding:** LCR (custom splash, theme, colours and tool menu)
- **One image** covers both `lavender` and `lavenderin`

## Features

| Area | Details |
|------|---------|
| Recovery | TWRP 3.7.1_14 based, portrait theme, custom LCR splash/theme |
| Decryption | FBE / FDE via QTI keymaster + gatekeeper (metadata decrypt) |
| Magisk | Bundled in the ramdisk; `lcr-magisk.sh` patches the boot image (user zip optional) |
| Utilities | bash, nano, tar, xz, parted, ntfs-3g, plus LCR shell tools (`lcr-*.sh`) |
| Backup | `lcr-backup-efs.sh` dumps EFS / persist / modem / fsg / fsc |
| Flash / EDL | `lcr-flash.sh`; `lcr-edl.sh` reboots to Qualcomm EDL (9008); fastbootd + ADB sideload |
| Maintenance | `lcr-verity.sh`, `lcr-mountrw.sh`, `lcr-selinux.sh`, `lcr-wipe.sh`, `lcr-partitions.sh`, `lcr-kernel.sh` |
| Device fixes | Touch, brightness, RTC, OTG, temperature, USB |
| Tool menu | Advanced → **LCR Tools** (terminal) → `lcr-tools` |

## Layout

```
device/xiaomi/lavender/     device tree (BoardConfig, product, ramdisk, prebuilt kernel)
theme/portrait_hdpi/        theme overlay assets + custom splash.xml
scripts/                    gen_assets.sh, apply_theme.py
splash/                     splash preview
.github/workflows/build.yml CI build
```

## Building

### GitHub Actions (recommended)

Push a tag or run the workflow manually:

```
git tag v1.0 && git push origin v1.0
```

The workflow syncs the TWRP 14.1 minimal manifest, injects this device tree,
applies the LCR theme, builds `mka recoveryimage` and uploads the image as an
artifact / GitHub Release.

### Local

```bash
mkdir android && cd android
repo init --depth=1 -u https://github.com/minimal-manifest-twrp/platform_manifest_twrp_aosp.git -b twrp-14.1
repo sync -j"$(nproc)" --force-sync --no-clone-bundle --no-tags

mkdir -p device/xiaomi
cp -r /path/to/lcr/device/xiaomi/lavender device/xiaomi/lavender
cp -r /path/to/lcr/theme   theme
cp -r /path/to/lcr/scripts scripts

python3 scripts/apply_theme.py bootable/recovery

export ALLOW_MISSING_DEPENDENCIES=true
source build/envsetup.sh
lunch twrp_lavender-ap2a-eng
mka recoveryimage
```

Output: `out/target/product/lavender/recovery.img`

## Flashing

```bash
fastboot flash recovery recovery-LCR-lavender.img
```

Devices with AVB enabled (unlocked bootloader) may also need:

```bash
fastboot --disable-verity --disable-verification flash vbmeta vbmeta.img
```

> [!WARNING]
> Flashing a custom recovery voids warranties and can brick a device if done
> incorrectly. You are responsible for your own device. Keep an EFS/persist
> backup (`Advanced → LCR Tools → lcr-backup-efs`).

## Credits

- [TeamWin Recovery Project](https://github.com/TeamWin) — TWRP
- [Minimal manifest TWRP](https://github.com/minimal-manifest-twrp)
- Xiaomi `lavender` device blobs (keymaster / gatekeeper / qseecomd)
