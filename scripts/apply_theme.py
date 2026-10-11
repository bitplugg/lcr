#!/usr/bin/env python3
#
# LCR (Lavender Custom Recovery) - theme/splash patcher.
#
# Patches a bootable/recovery checkout so the built recovery uses the LCR
# branding, colours, splash screen and Advanced-menu tool entries.
#
# Usage:
#   python3 scripts/apply_theme.py [/path/to/bootable/recovery]
#
import os
import re
import shutil
import sys

HERE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
THEME_SRC = os.path.join(HERE, "theme")
IMAGES_SRC = os.path.join(THEME_SRC, "portrait_hdpi", "images")

recovery = sys.argv[1] if len(sys.argv) > 1 else os.environ.get(
    "RECOVERY_PATH", os.path.join(os.getcwd(), "bootable/recovery"))
theme = os.path.join(recovery, "gui", "theme")
hdpi = os.path.join(theme, "portrait_hdpi")
common = os.path.join(theme, "common")

if not os.path.isdir(hdpi):
    sys.exit("apply_theme: %s not found (bootable/recovery tree?)" % hdpi)


def patch(path, repl):
    with open(path, "r", encoding="utf-8") as fh:
        data = fh.read()
    new = data
    for old, val in repl:
        new = new.replace(old, val)
    if new != data:
        with open(path, "w", encoding="utf-8") as fh:
            fh.write(new)
        print("apply_theme: patched %s" % os.path.relpath(path, recovery))
    else:
        print("apply_theme: no change %s" % os.path.relpath(path, recovery))


# 1) Colours in portrait_hdpi/ui.xml
ui = os.path.join(hdpi, "ui.xml")
patch(ui, [
    ('<variable name="background_color" value="#1A1A1A"/>',
     '<variable name="background_color" value="#1A1520"/>'),
    ('<variable name="accent_color" value="#0090CA"/>',
     '<variable name="accent_color" value="#A97BFF"/>'),
    ('<variable name="accent_color_semitransparent" value="#0090CA30"/>',
     '<variable name="accent_color_semitransparent" value="#A97BFF30"/>'),
    ('<variable name="highlight" value="#0090CA"/>',
     '<variable name="highlight" value="#A97BFF"/>'),
    ("#0090CA80", "#A97BFF80"),
])

# 2) Custom splash screen
splash_src = os.path.join(THEME_SRC, "portrait_hdpi", "splash.xml")
if os.path.isfile(splash_src):
    shutil.copyfile(splash_src, os.path.join(hdpi, "splash.xml"))
    print("apply_theme: replaced portrait_hdpi/splash.xml")

# 3) Custom images
for img in ("logo.png", "splashlogo.png", "splashteamwin.png"):
    src = os.path.join(IMAGES_SRC, img)
    if os.path.isfile(src):
        shutil.copyfile(src, os.path.join(hdpi, "images", img))
        print("apply_theme: installed image %s" % img)

# 4) Brand text + Advanced-menu tool entries in common/portrait.xml
portrait = os.path.join(common, "portrait.xml")
patch(portrait, [
    ("{@twrp_header=Team Win Recovery Project}", "{@twrp_header=LCR Recovery}"),
])

with open(portrait, "r", encoding="utf-8") as fh:
    data = fh.read()

if "lcr_tools_btn" not in data:
    anchor = ('<listitem name="{@reload_theme_btn=Reload Theme}">\n'
              '\t\t\t\t\t<action function="reload"/>\n'
              '\t\t\t\t</listitem>')
    if anchor not in data:
        sys.exit("apply_theme: reload-theme anchor not found; theme layout changed")

    items = """
				<listitem name="{@lcr_tools_btn=LCR Tools (terminal)}">
					<actions>
						<action function="set">tw_back=advanced</action>
						<action function="page">terminalcommand</action>
					</actions>
				</listitem>
				<listitem name="{@lcr_magisk_btn=Install Magisk (patch boot)}">
					<actions>
						<action function="set">tw_back=advanced</action>
						<action function="set">tw_terminal_location=/sdcard</action>
						<action function="set">tw_action=terminalcommand</action>
						<action function="set">tw_action_param=/system/bin/lcr-magisk.sh</action>
						<action function="set">tw_action_text1={@lcr_magisk_btn=Install Magisk (patch boot)}</action>
						<action function="set">tw_complete_text1={@lcr_done=Done}</action>
						<action function="page">action_page</action>
					</actions>
				</listitem>
				<listitem name="{@lcr_edl_btn=Reboot to EDL (9008)}">
					<actions>
						<action function="set">tw_back=advanced</action>
						<action function="set">tw_terminal_location=/sdcard</action>
						<action function="set">tw_action=terminalcommand</action>
						<action function="set">tw_action_param=/system/bin/lcr-edl.sh</action>
						<action function="set">tw_action_text1={@lcr_edl_btn=Reboot to EDL (9008)}</action>
						<action function="set">tw_complete_text1={@lcr_done=Done}</action>
						<action function="page">action_page</action>
					</actions>
				</listitem>
				<listitem name="{@lcr_backup_btn=Backup EFS / persist}">
					<actions>
						<action function="set">tw_back=advanced</action>
						<action function="set">tw_terminal_location=/sdcard</action>
						<action function="set">tw_action=terminalcommand</action>
						<action function="set">tw_action_param=/system/bin/lcr-backup-efs.sh</action>
						<action function="set">tw_action_text1={@lcr_backup_btn=Backup EFS / persist}</action>
						<action function="set">tw_complete_text1={@lcr_done=Done}</action>
						<action function="page">action_page</action>
					</actions>
				</listitem>
				<listitem name="{@lcr_verity_btn=Remove dm-verity / forceencrypt}">
					<actions>
						<action function="set">tw_back=advanced</action>
						<action function="set">tw_terminal_location=/sdcard</action>
						<action function="set">tw_action=terminalcommand</action>
						<action function="set">tw_action_param=/system/bin/lcr-verity.sh</action>
						<action function="set">tw_action_text1={@lcr_verity_btn=Remove dm-verity / forceencrypt}</action>
						<action function="set">tw_complete_text1={@lcr_done=Done}</action>
						<action function="page">action_page</action>
					</actions>
				</listitem>"""

    data = data.replace(anchor, anchor + items)
    with open(portrait, "w", encoding="utf-8") as fh:
        fh.write(data)
    print("apply_theme: added LCR tool entries to Advanced menu")
else:
    print("apply_theme: LCR tool entries already present")

print("apply_theme: done")
