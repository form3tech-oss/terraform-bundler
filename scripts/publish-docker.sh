#!/usr/bin/env bash

set -euo pipefail

WORK_DIR="$(git rev-parse --show-toplevel)"
TERRAFORM_VERSION=$1
SIMPLIFIED_TERRAFORM_VERSION=""

function copy_bundle() {
  if [ -d "docker/bundle.zip" ]; then rm docker/bundle.zip; fi
  cp $WORK_DIR/build/terraform_*.zip docker/bundle.zip
}

function set_terraform_version() {
  SIMPLIFIED_TERRAFORM_VERSION="$(awk -F. '{print $1}' <<< $TERRAFORM_VERSION).$(awk -F. '{print $2}' <<< $TERRAFORM_VERSION)"
  echo "TERRAFORM_VERSION:$TERRAFORM_VERSION"
  echo "SIMPLIFIED_TERRAFORM_VERSION:$SIMPLIFIED_TERRAFORM_VERSION"
}

function build_container {
	echo "building $1 with tag $TAG"
	docker build -t tech.form3/$1:$TAG $WORK_DIR/docker/.

	docker tag tech.form3/$1:$TAG ${PRIMARY_DOCKER_REGISTRY}/tech.form3/$1:$TAG
	docker tag tech.form3/$1:$TAG ${SECONDARY_DOCKER_REGISTRY}/tech.form3/$1:$TAG

  if [ "$2" = "publish" ]; then
		echo "Publishing $1:$TAG to PRIMARY_DOCKER_REGISTRY"
		eval $(aws ecr get-login --region eu-west-1 --no-include-email)
		docker push ${PRIMARY_DOCKER_REGISTRY}/tech.form3/$1:$TAG

		echo "Publishing $1:$TAG to SECONDARY_DOCKER_REGISTRY"
		eval $(aws ecr get-login --region eu-west-2 --no-include-email)
		docker push ${SECONDARY_DOCKER_REGISTRY}/tech.form3/$1:$TAG

		echo "Finished publishing to docker registry"
	elif [ "$2" = "scan" ]; then
		docker save -o image.tar tech.form3/$1:$TAG
		eval $(aws ecr get-login --region eu-west-1 --no-include-email)
		docker run --privileged -v $(pwd):/code -e DOCKERFILE_PATH=./$1/Dockerfile -e SNYK_TOKEN -e TRAVIS ${PRIMARY_DOCKER_REGISTRY}/tech.form3/secscan-docker
		rm image.tar
	fi
}

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
copy_bundle
set_terraform_version
TAG="$SIMPLIFIED_TERRAFORM_VERSION-$TAG"
build_container "form3-terraform-bundle" "publish"