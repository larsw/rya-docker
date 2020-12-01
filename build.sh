#!/bin/sh

set -e

WAR=web2.rya.war

if [ ! -f "$WAR" ]; then
  echo "You need to copy $WAR into the directory before you build, exiting..."
  exit -1
fi

export DOCKER_BUILDKIT=1

docker build -t larsw/rya:alpine .
docker tag larsw/rya:alpine larsw/rya:latest
