#!/usr/bin/env bash

set -euxo pipefail

function build() {
    local platform=$1
    local artifact_name=$2

    CGO_ENABLED=0 GOOS="$platform" go build -trimpath -o "$artifact_name"
}

if [[ ! $(command -v git) ]]; then
    echo "git is required"
    exit 1
fi

TF_TAG=$1
TF_REPO="https://github.com/hashicorp/terraform"
BUNDLE_PATH="tools/terraform-bundle"

tmp=$(mktemp -d)
bundler_dir=$(pwd)

cd "$tmp"
git clone --single-branch --depth 1 -b "$TF_TAG" "$TF_REPO" .
cd "${BUNDLE_PATH}"

PLATFORMS="linux darwin"

for platform in $PLATFORMS; do
    artifact="terraform-bundle-${TF_TAG#v}_${platform}_amd64"
    build "$platform" "$artifact"
    cp "$tmp/$BUNDLE_PATH/$artifact" "$bundler_dir/bin/"
done

rm -rf "$tmp"
