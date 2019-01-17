#!/bin/bash
docker build -t ozlevka/jenkins-ansible:latest .
TAG=`date +"%y%m%d-%H.%M"`
docker tag ozlevka/jenkins-ansible:latest "ozlevka/jenkins-ansible:$TAG"
#docker push "ozlevka/jenkins:$TAG"