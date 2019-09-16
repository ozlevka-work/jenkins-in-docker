#!/bin/bash -e

if [ -z "$1" ]; then
    TAG=`date +"%y%m%d-%H.%M"`
else
    TAG=$1
fi

docker tag ozlevka/jenkins:latest "ozlevka/jenkins:$TAG"
docker push "ozlevka/jenkins:$TAG"
