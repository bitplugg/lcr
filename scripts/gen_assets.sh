#!/usr/bin/env bash
#
# LCR (Lavender Custom Recovery) - generate theme/splash image assets.
# Requires ImageMagick (convert / magick).
#
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT="${HERE}/theme/portrait_hdpi/images"
SPLASH_OUT="${HERE}/splash"
mkdir -p "$OUT" "$SPLASH_OUT"

FONT_TITLE="/usr/share/fonts/Orbitron Black.ttf"
FONT_MONO="/usr/share/fonts/truetype/JetBrainsMono-ExtraBold.ttf"
[ -f "$FONT_MONO" ] || FONT_MONO="/usr/share/fonts/ARCADECLASSIC.TTF"

ACCENT="#A97BFF"
ACCENT_D="#6D3FD6"
BG="#1A1520"

magick_cmd() { command -v magick >/dev/null 2>&1 && echo magick || echo convert; }
M="$(magick_cmd)"

# --- logo.png : 184x256 monogram for the main screen ---
"$M" -size 184x256 xc:none \
    -font "$FONT_TITLE" -pointsize 62 -gravity North -fill "$ACCENT" -annotate +0+58 "LCR" \
    -font "$FONT_TITLE" -pointsize 15 -gravity North -fill "#EDE6FF" -annotate +0+132 "RECOVERY" \
    "$OUT/logo.png"

# --- splashlogo.png : 500x500 centered splash mark ---
"$M" -size 360x360 gradient:"${ACCENT_D}-${ACCENT}" /tmp/lcr_grad.png
"$M" -size 360x360 xc:none -fill white -draw "roundrectangle 0,0 359,359 48,48" /tmp/lcr_mask.png
"$M" /tmp/lcr_grad.png /tmp/lcr_mask.png -alpha off -compose CopyOpacity -composite /tmp/lcr_badge.png
"$M" /tmp/lcr_badge.png -background none -gravity center -extent 500x500 \
    -font "$FONT_TITLE" -pointsize 108 -gravity center -fill white -annotate +0+0 "LCR" \
    "$OUT/splashlogo.png"

# --- splashteamwin.png : 708x96 footer wordmark ---
"$M" -size 708x96 xc:none \
    -font "$FONT_TITLE" -pointsize 30 -gravity Center -fill "$ACCENT" \
    -annotate +0-8 "LAVENDER CUSTOM RECOVERY" \
    -font "$FONT_TITLE" -pointsize 18 -gravity Center -fill "#EDE6FF" \
    -annotate +0+28 "Redmi Note 7 / Note 7S" \
    "$OUT/splashteamwin.png"

# --- splash background (optional standalone preview) ---
"$M" -size 1080x1920 xc:"$BG" "$SPLASH_OUT/splash_preview.png"

echo "LCR: assets generated in $OUT"
