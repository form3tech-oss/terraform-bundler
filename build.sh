#!/usr/bin/env bash
set -e

function build_container {
	echo "building $1 with tag $TAG"

	if [ -f $1/DockerArgs ]; then
		DOCKERARGS=`(eval echo -E $(cat $1/DockerArgs))`
		docker build --build-arg "$DOCKERARGS" -t tech.form3/$1:$TAG ./$1
	else
		docker build -t tech.form3/$1:$TAG ./$1
	fi


    if [ "$2" = "publish" ]; then

        for region in $(echo "eu-west-1,eu-west-2" | sed "s/,/ /g")
        do
            echo "Publising $1:$TAG to $region"
            eval $(aws ecr get-login --region $region --no-include-email)
            docker tag tech.form3/$1:$TAG $ACCOUNT_ID.dkr.ecr.$region.amazonaws.com/tech.form3/$1:$TAG
            docker push $ACCOUNT_ID.dkr.ecr.$region.amazonaws.com/tech.form3/$1:$TAG
        done
	fi
}

if [ -z ${ACCOUNT_ID+x} ]; then
	echo "Need to specify the ACCOUNT_ID env variable to publish the docker containers"
	exit
fi


if [ -z ${TRAVIS_PULL_REQUEST+x} ]; then
	TRAVIS_PULL_REQUEST="false"
fi

if [ -z ${TRAVIS_BRANCH+x} ]; then
	TRAVIS_BRANCH="develop"
fi

if [ "$TRAVIS_PULL_REQUEST" = "false" ]; then
	TAG=$TRAVIS_BRANCH
else
	TAG="$TRAVIS_PULL_REQUEST_BRANCH-pr"
fi

if [ "$TAG" = "" ]; then
    TAG=$(git rev-parse --abbrev-ref HEAD)
fi

if [ "$TAG" = "master" ]; then
    TAG="latest"
fi

CONTAINER_NAME="$(basename $(git rev-parse --show-toplevel))"
CONTAINER_NAME="${CONTAINER_NAME/docker-/}"
echo $CONTAINER_NAME

build_container $CONTAINER_NAME $1


