#!/system/bin/sh
#
# LCR (Lavender Custom Recovery) - boot banner
# Prints the LCR ASCII art banner to all available consoles.
#

BANNER='
  _      ____  ____
 | |    / ___||  _ \
 | |   | |    | |_) |
 | |___| |___ |  _ <
 |_____|\____||_| \_\

   Lavender Custom Recovery
   Redmi Note 7 / Note 7S
   (lavender / lavenderin)
'

for out in /dev/kmsg /dev/tty0 /dev/console; do
    if [ -w "$out" ]; then
        printf '%s\n' "$BANNER" > "$out" 2>/dev/null
    fi
done

printf '%s\n' "$BANNER"
exit 0
