#!/usr/bin/env bash

yazi --chooser-file=/tmp/wallpaper_path

if [ -f /tmp/wallpaper_path ]; then
    CHOICE=$(cat /tmp/wallpaper_path)

    wal -i "$CHOICE"

    dbus-send --session --dest=org.kde.plasmashell --type=method_call /PlasmaShell org.kde.PlasmaShell.evaluateScript "string:
    var allDesktops = desktops();
    for (var i = 0; i < allDesktops.length; i++) {
        var d = allDesktops[i];
        d.currentConfigGroup = Array('Wallpaper', 'org.kde.image', 'General');
        d.writeConfig('Image', 'file://$CHOICE');
    }"

    rm /tmp/wallpaper_path
fi
exit 0
