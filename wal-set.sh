#!/usr/bin/env bash

# 1. Lancer Yazi pour choisir l'image
# On utilise --chooser-file pour que Yazi écrive le chemin et s'arrête
yazi --chooser-file=/tmp/wallpaper_path

# 2. Vérifier si un fichier a été sélectionné
if [ -f /tmp/wallpaper_path ]; then
    CHOICE=$(cat /tmp/wallpaper_path)

    # Appliquer Pywal (on ne met pas de & ici pour être sûr que ça s'exécute)
    # On force la mise à jour des séquences du terminal
    wal -i "$CHOICE"

    # 3. Envoyer l'image à KDE via DBUS
    dbus-send --session --dest=org.kde.plasmashell --type=method_call /PlasmaShell org.kde.PlasmaShell.evaluateScript "string:
    var allDesktops = desktops();
    for (var i = 0; i < allDesktops.length; i++) {
        var d = allDesktops[i];
        d.currentConfigGroup = Array('Wallpaper', 'org.kde.image', 'General');
        d.writeConfig('Image', 'file://$CHOICE');
    }"

    # Nettoyage
    rm /tmp/wallpaper_path
fi

# 4. Fermer Kitty proprement
exit 0
