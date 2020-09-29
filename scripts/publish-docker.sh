#!/usr/bin/env bash

TERRAFORM_VERSION=$1
REPO="form3tech-oss/terraform-bundler"
WORK_DIR="$(git rev-parse --show-toplevel)"
BUNDLE_FILE_NAME="$(ls $WORK_DIR/build/*.zip)"
BUNDLE_SHA=$(shasum -a256 $BUNDLE_FILE_NAME| awk '{print $1}')
BUNDLE_VERSION=$(echo $BUNDLE_FILE_NAME | cut -d '_' -f 2 )

if [ -d "docker/bundle.zip" ]; then rm docker/bundle.zip; fi

cp $WORK_DIR/build/terraform_*.zip docker/bundle.zip

docker build $WORK_DIR/docker/. -t form3tech/form3-terraform-bundle