#/bin/bash

mkdir -p etcsnap
cd etcsnap

if [ -d .git ]; then
    git log -1
else
    git init
fi

mkdir -p etc

mount --bind /etc/ etc/

git add -A etc
git status
git commit -m "committing all files in the /etc/* configuration folder"

umount etc

