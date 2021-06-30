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
    wget "https://github.com/gruntwork-io/fetch/releases/download/v0.3.6/fetch_${RUNNING_PLATFORM}_amd64" -O bin/fetch && chmod a+x bin/fetch
fi

# Delete any previously downloaded release for the current provider.
rm -f terraform-provider-"${PROVIDER_NAME}"*.zip

# Fetch the requested release.
bin/fetch --tag="${PROVIDER_VERSION}" --repo="${PROVIDER_GITHUB_URL}" --release-asset="terraform-provider-${PROVIDER_NAME}_.*_${ARCH}_amd64.zip" --github-oauth-token="${GITHUB_TOKEN}" .

# Unzip the downloaded release.
unzip -o terraform-provider-"${PROVIDER_NAME}"*.zip -d "${OUTPUT_DIRECTORY}"

pushd "${OUTPUT_DIRECTORY}" > /dev/null

if [[ $TERRAFORM_VERSION =~ 0\.1[12]\. ]]; then
    # Make sure that the resulting binary is correctly named ('terraform-provider-<name>_<version>', where '<version>' starts with a 'v').
    [[ ${PROVIDER_VERSION} == v* ]] || PROVIDER_VERSION="v${PROVIDER_VERSION}"
    [[ -f "terraform-provider-${PROVIDER_NAME}" ]] && mv "terraform-provider-${PROVIDER_NAME}" "terraform-provider-${PROVIDER_NAME}_${PROVIDER_VERSION}"
else
    # Terraform versions >= 0.13 require a different directory structure in order to locate locally installed plugins.
    # Details on the strucuture can be found at https://github.com/hashicorp/terraform/tree/main/tools/terraform-bundle#plugins-directory-layout.
    [[ ${PROVIDER_VERSION} == v* ]] || PROVIDER_VERSION="v${PROVIDER_VERSION}"
    PROVIDER_VERSION_NO_V="$(echo "$PROVIDER_VERSION" | sed -e 's/^v//')"

    SOURCEHOST="$(echo "$PROVIDER_GITHUB_URL" | cut -d/ -f3)"
    SOURCENAMESPACE="$(echo "$PROVIDER_GITHUB_URL" | cut -d/ -f4)"

    PLUGIN_DIR="$OUTPUT_DIRECTORY/$SOURCEHOST/$SOURCENAMESPACE/$PROVIDER_NAME/$PROVIDER_VERSION_NO_V/${ARCH}_amd64"
    PLUGIN_PATH="$PLUGIN_DIR/terraform-provider-${PROVIDER_NAME}"
    mkdir -p "$PLUGIN_DIR"

    if [[ -f "terraform-provider-${PROVIDER_NAME}_${PROVIDER_VERSION}" ]]; then
        mv "terraform-provider-${PROVIDER_NAME}_${PROVIDER_VERSION}" "$PLUGIN_PATH"
    else
        mv "terraform-provider-${PROVIDER_NAME}" "$PLUGIN_PATH"
    fi
fi

popd > /dev/null

# Delete the downloaded release.
rm -f terraform-provider-"${PROVIDER_NAME}"*.zip

popd > /dev/null
