#!/bin/bash

# test that the current directory is in a valid btrfs partition and report if otherwise
if ! btrfs su li . > /dev/null ; then
    exit 1
fi


TODAY=`date +%g%m%d`
NOW=`date +%H%M%S`
STAMP="${TODAY}.${NOW}"

echo "timestamp: $STAMP"

SIFS=$IFS
IFS=$'\n' # set the Internal Field Separator to newline

svlist=`btrfs subvolume list . | cut -d ' ' -f 9 | grep -v "\.snapshots\/"` # extract subvolume names


if [ $# -eq 0 ]
    # no arguments supplied, snapshot all subvolumes
  then
    for path in $svlist ; do
      subvol=$(basename -- "$path")   # remove leading path, if present
      echo $subvol
      mkdir -p .snapshots
      btrfs subvolume snapshot -r $path  .snapshots/${STAMP}.$subvol
    done

else

    # loop over all paths provided in the input
    for spath in $@ ; do

      # convert the path to a format identical to that provided by btrfs su li,
      #  i.e. skip ./ for paths on root directory but preserve full paths to subvolume otherwise, and
      #  remove any trailing or redundant slashes from the pathname

      # basename and dirname remove any trailing slash(es) whenever present
      path="$(basename -- "$spath")"
      dir="$(dirname -- "$spath")"

      if [ "$dir" != "." ]; then
        path="$dir/$path"
      fi


      # first path for existence and validity first
      if [[ -e $path ]] ; then

	found=0

	# look for a matching subvolume from our list
	for sv in $svlist; do

	  # check if path matches subvolume name
          if [ "$sv" = "$path" ]; then
	      found=1
	      subvol=$(basename -- "$path")   # remove leading path, if present
	      mkdir -p .snapshots
	      btrfs subvolume snapshot -r $path  .snapshots/${STAMP}.$subvol
	  fi
	done

	# if no match was found, complain
	if [ "$found" = 0 ] ; then
	    echo path \"$path\" is not a valid btrfs subvolume
        fi

      # the path wasn't valid
      else 
        echo path \"$path\" does not exist
      fi

    done

fi

IFS=$SIFS # reset IFS to previous value

