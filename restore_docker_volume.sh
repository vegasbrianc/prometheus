#!/bin/bash
if [ $# -eq 0 ]
  then
    echo "Please supply the backup file in the format: "
    echo "restore_docker_volume.sh /path/backup_file-20001212_000000.tar.gz"
    echo " "
    exit
fi

pathToFile=$(pwd $(dirname $1))
fileName=$(basename $1)
VOLUME=$(echo $fileName | sed 's/\(.*\)-[0-9]*_[0-9]*\.tar\.gz/\1/')
# Check if docker volume exists
if docker volume ls -q | grep -q $VOLUME ; then
    read -p "Volume already exists, overwrite all files? [yn] " -n 1 -r
    echo    # (optional) move to a new line
    if [[ ! $REPLY =~ ^[Yy]$ ]]
    then
        [[ "$0" = "$BASH_SOURCE" ]] && exit 1 || return 1
    fi
else
    echo "Creating volume $VOLUME"
    #docker volume create $VOLUME
fi
echo Restore volume: $VOLUME
docker run -d \
  --name=restore-$VOLUME \
  --rm \
  -v $pathToFile/:/source:ro \
  -v $VOLUME:/$VOLUME \
  alpine \
  tar zvxf /source/$fileName -C /source --strip-components 1
