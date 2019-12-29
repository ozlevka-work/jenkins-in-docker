#!/bin/bash
docker build -t ozlevka/jenkins:latest .

if [[ "$1" = "upload" ]]; then
    TAG=`date +"%y%m%d-%H.%M"`
    docker tag ozlevka/jenkins:latest "ozlevka/jenkins:$TAG"
    docker push "ozlevka/jenkins:$TAG"
fi
