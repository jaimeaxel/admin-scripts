
snap.sh : creates a timestamped read-only snapshot for each subvolumes in a BTRFS partition, or a subset thereof specified in the argument list; must be run in the root directory; all subvol snapshots are stored in /.snapshots folder

snapall.sh: mounts all known BTRFS partitions and runs snap.sh on each of them

snapetc.sh: in its first run creates a new git repository inside a new ./etcsnap folder; on first as well as all subsequent runs it bind-mounts /etc in the subfolder ./etcsnap/etc, commits all changes in the configuration files to the repository

undelete.sh: attempts to recover deleted files from a BTRFS filesystem. all credit due to the original author

