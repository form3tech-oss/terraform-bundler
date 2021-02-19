#!/usr/bin/env bash

set -euo pipefail

REPO_WORK_DIR="$(git rev-parse --show-toplevel)"
PROVIDER_NAME=$1
PROVIDER_VERSION=$2
PROVIDER_GITHUB_URL=$3
RUNNING_PLATFORM=$4
ARCH=$5
OUTPUT_DIRECTORY="${REPO_WORK_DIR}/build/plugins"

pushd "${REPO_WORK_DIR}" > /dev/null

# Download 'fetch' if it doesn't already exist.
if [[ ! -f bin/fetch ]]; then
    mkdir -p bin
    wget "https://github.com/gruntwork-io/fetch/releases/download/v0.3.6/fetch_${RUNNING_PLATFORM}_amd64" -O bin/fetch && chmod a+x bin/fetch
fi

# Delete any previously downloaded release for the current provider.
rm -f terraform-provider-"${PROVIDER_NAME}"*.zip

# Fetch the requested release.
bin/fetch --tag="${PROVIDER_VERSION}" --repo="${PROVIDER_GITHUB_URL}" --release-asset="terraform-provider-${PROVIDER_NAME}_.*_${ARCH}_amd64.zip" --github-oauth-token="${GITHUB_TOKEN}" .

# Unzip the downloaded release.
unzip -o terraform-provider-"${PROVIDER_NAME}"*.zip -d "${OUTPUT_DIRECTORY}"

pushd "${OUTPUT_DIRECTORY}" > /dev/null

# Make sure that the resulting binary is correctly named ('terraform-provider-<name>_<version>', where '<version>' starts with a 'v').
[[ ${PROVIDER_VERSION} == v* ]] || PROVIDER_VERSION="v${PROVIDER_VERSION}"
[[ -f "terraform-provider-${PROVIDER_NAME}" ]] && mv "terraform-provider-${PROVIDER_NAME}" "terraform-provider-${PROVIDER_NAME}_${PROVIDER_VERSION}"

popd > /dev/null

# Delete the downloaded release.
rm -f terraform-provider-"${PROVIDER_NAME}"*.zip

popd > /dev/null
