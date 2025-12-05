#!/usr/bin/env bash

set -e

run() {
    echo -e "sh: \033[1;32m$*\033[0m"
    sudo "$@"
}

list_snapshots() {
    run mount -o compress=zstd:3,subvol=/ "$DEVICE" /mnt
    snapshot_dates=$(ls /mnt/.snapshots | grep '@-' | sed 's/@-//' | sort -u)
    
    if [ -z "$snapshot_dates" ]; then
        echo -e "\033[1;31mNo snapshots found.\033[0m"
        run umount /mnt
        return
    fi

    # Check if each date has a corresponding home snapshot
    for date in $snapshot_dates; do
        if ! ls /mnt/.snapshots | grep -q "@home-$date"; then
            echo -e "\033[1;33mWarning: No home snapshot for date $date!\033[0m"
        fi
    done

    # Display the list of dates
    echo -e "\n\033[1;32mSnapshots found for the following dates:\033[0m"
    for date in $snapshot_dates; do
        echo -e "\033[1;36m$date\033[0m"
    done

    run umount /mnt
}

DEVICE=$(findmnt -n -o SOURCE /home | sed 's/\[.*\]//')

echo "List all devices"
df -h | grep nvme
df -h | grep sd
echo -e "Selected device: \033[1;32m$DEVICE\033[0m"
echo

list_snapshots