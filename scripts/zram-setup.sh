#!/usr/bin/env bash

export ZRAM_SIZE=1024M

/usr/bin/modprobe zram
echo zstd > /sys/block/zram0/comp_algorithm
echo ${ZRAM_SIZE}M >/sys/block/zram0/disksize
/usr/bin/mkswap --label steam-zram /dev/zram0
/usr/bin/swapon --priority 100 /dev/zram0
