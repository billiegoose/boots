#! /usr/bin/env bash
set -e
./makefloppy.sh

SIZE=3789504

# This command is very very careful to only select my USB device by partition size
DEV=$(cat /proc/partitions | awk '$3 == '${SIZE}' && $5==NIL {print $4}')
WC=$(echo $DEV | wc -w)

if [[ -z $DEV ]]; then
  echo "Did not find USB drive"
elif [[ $WC != 1 ]]; then
  echo "Found more than one flash drive:"
  echo "$DEV"
else
  echo "Located USB drive: $DEV"
  read -r -n 1 -p "Blast MBR of /dev/$DEV? [y/N] " result
  echo ""
  if [[ "$result" == "y" ]]; then
    echo "Copying myos.img to /dev/$DEV..."
    dd if="myos.img" of="/dev/$DEV"
    sync
    echo "Complete."
  fi
fi