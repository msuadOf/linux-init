#!/usr/bin/env bash

set -e

run() {
    if [ -z "$is_fake" ] || [ "$is_fake" = false ]; then
        echo -e "sh: \033[1;32m$*\033[0m"
        sudo "$@" > /dev/null
    else
        echo -e "> \033[1;32m$*\033[0m"
    fi
}

make_snapshot() {
    NOW_DATE=$(date +"%Y%m%d%m_%H:%M:%S")
    run apt autoclean -y
    run mount -o compress=zstd:3,subvol=/ "$DEVICE" /mnt
    
    SNAPSHOT_FROM="/mnt/@"
    SNAPSHOT_TO="/mnt/.snapshots/@-$NOW_DATE"
    SNAPSHOT_NAME=".snapshots/@-$NOW_DATE"
    if [ "$is_fake" = false ] && sudo btrfs subvolume list /mnt -o | grep -q "$SNAPSHOT_NAME"; then
        run btrfs subvolume delete "$SNAPSHOT_TO"
    fi
    run btrfs subvolume snapshot -r "$SNAPSHOT_FROM" "$SNAPSHOT_TO"

    SNAPSHOT_FROM="/mnt/@home"
    SNAPSHOT_TO="/mnt/.snapshots/@home-$NOW_DATE"
    SNAPSHOT_NAME=".snapshots/@home-$NOW_DATE"
    if [ "$is_fake" = false ] && sudo btrfs subvolume list /mnt -o | grep -q "$SNAPSHOT_NAME"; then
        run btrfs subvolume delete "$SNAPSHOT_TO"
    fi
    run btrfs subvolume snapshot -r "$SNAPSHOT_FROM" "$SNAPSHOT_TO"

    run umount /mnt
}

DEVICE=$(findmnt -n -o SOURCE / | sed 's/\[.*\]//')

echo "List all devices"
df -h | grep nvme
echo -e "Selected device: \033[1;32m$DEVICE\033[0m"
echo
echo "Following commands will be executed:"
is_fake=true
make_snapshot

read -r -p "Are you sure? [y/N] " input
input=${input,,}
echo

if [ "$input" = "y" ]; then
    is_fake=false
    #make_snapshot
fi
make_snapshot
