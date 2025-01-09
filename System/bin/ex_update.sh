#!/bin/sh

UPDATES_DIR="/mnt/SDCARD/System/updates/"

if [ -f "/mnt/SDCARD/TRIMUI_EX.zip" ] && [ -e "/bin/bash" ]; then
    # This only works if the root code has been installed.
    sdl2imgshow \
        -i "$EX_RESOURCE_PATH/background.png" \
        -f "$EX_RESOURCE_PATH/DejaVuSans.ttf" \
        -s 48 \
        -c "0,0,0" \
        -t "Extracting TRIMUI_EX" &

    pkill -f sdl2imgshow

    echo "Updating TRIMUI_EX" >> "$UPDATES_DIR/update.log"
    unzip -o -d "/mnt/SDCARD/" "/mnt/SDCARD/TRIMUI_EX.zip" >> "$UPDATES_DIR/update.log"
    rm -f "/mnt/SDCARD/TRIMUI_EX.zip" >> "$UPDATES_DIR/update.log"
fi

RESTORE_DIR="$(cwd)"
cd "$UPDATES_DIR" || exit 1

for script in $(ls -1v update_*.sh); do
    sh "$script" >> "$UPDATES_DIR/update.log"
done

cd "$RESTORE_DIR"

if [ -d "/mnt/SDCARD/Apps/PortMaster" ]; then
    sdl2imgshow \
        -i "$EX_RESOURCE_PATH/background.png" \
        -f "$EX_RESOURCE_PATH/DejaVuSans.ttf" \
        -s 48 \
        -c "0,0,0" \
        -t "Installing PortMaster" &
    latest_url=$(curl -s https://api.github.com/repos/PortsMaster/PortMaster-GUI/releases/latest | grep '/PortMaster.zip"' | cut -d '"' -f 4)

    wget "$latest_url" -o /tmp/PortMaster.zip

    echo "Updating PortMaster" >> "$UPDATES_DIR/update.log"
    unzip -o -d "/mnt/SDCARD/" "/tmp/PortMaster.zip" >> "$UPDATES_DIR/update.log"

    mkdir -p /roms/ports/PortMaster/
    cp /mnt/SDCARD/Apps/PortMaster/PortMaster/trimui/control.txt /roms/ports/PortMaster/control.txt

    pkill -f sdl2imgshow
fi

if [ ! -f /roms/ports/PortMaster/control.txt ] && [ -f /mnt/SDCARD/Apps/PortMaster/PortMaster/trimui/control.txt ]; then
    # Fix PortMaster
    mkdir -p /roms/ports/PortMaster/
    cp /mnt/SDCARD/Apps/PortMaster/PortMaster/trimui/control.txt /roms/ports/PortMaster/control.txt
fi

if [ -f /mnt/SDCARD/Apps/launch.sh ]; then
    # Fix launcher
    mv -fv /mnt/SDCARD/Apps/launch.sh /mnt/SDCARD/Apps/PortMaster/launch.sh
fi

if [ -f "/mnt/SDCARD/Apps/PortMaster/PortMaster/.trimui-refresh" ]; then
  rm -f "/mnt/SDCARD/Apps/PortMaster/PortMaster/.trimui-refresh"
  # HULK SMASH

  /mnt/SDCARD/Apps/PortMaster/PortMaster/trimui/image_smash.txt
fi
