#!/bin/bash


if [[ $1 == '-a' ]]; then
    VOLUMES=$(docker volume ls -q)
elif [[ $1 ]]; then
   if `docker volume ls -q |grep -w $1` ; then
        VOLUMES=$1
    else
      echo "Volume $1 does not exist."
      exit
    fi
else
    echo "No parameter passed, provide a volume name or '-a' to backup all volumes."
    exit
fi

for i in $VOLUMES; do
    echo Backup volume: $i
    export DOCKER_VOLUME=$i
    docker run -d \
      --name=backup-$i \
      --rm \
      -v $DOCKER_VOLUME:/$DOCKER_VOLUME:ro \
      -v /mnt/1TB-WDred/Backups/:/backup \
      alpine \
      tar -czpf /backup/$DOCKER_VOLUME-$(date +%Y%m%d_%H%M%S).tar.gz $DOCKER_VOLUME
done
