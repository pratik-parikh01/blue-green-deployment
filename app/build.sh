
DOCKER_REPO="pratikparikh/sample-app"
DOCKER_TAG=$1

docker build -t $DOCKER_REPO:$DOCKER_TAG
docker push $DOCKER_REPO:$DOCKER_TAG # docker login is implicitly assumed
