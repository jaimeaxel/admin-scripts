#!/bin/bash

# should probably scan  fstab for btrfs system mounts
# plus maybe don't use preexisting mountpoints
for dir in `ls -d p?` ; do
    echo $dir
    mount $dir
    cd $dir
    bash ./snap.sh
    cd ..
    umount $dir
done
