docker build -t ozlevka/jenkins:latest .
TAG=`date +"%y%m%d-%H.%M"`
docker tag ozlevka/jenkins:latest "ozlevka/jenkins:$TAG"
docker push "ozlevka/jenkins:$TAG"