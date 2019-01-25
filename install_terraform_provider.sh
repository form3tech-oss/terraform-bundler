#!/usr/bin/env bash
PROVIDER_NAME=$1
PROVIDER_VERSION=$2
PROVIDER_GITHUB_URL=$3
ARCH="linux"

echo Installing ${PROVIDER_NAME} version ${PROVIDER_VERSION} from ${PROVIDER_GITHUB_URL} architecture ${ARCH}
wget ${PROVIDER_GITHUB_URL}/releases/download/v${PROVIDER_VERSION}/terraform-provider-${PROVIDER_NAME}_${PROVIDER_VERSION}_${ARCH}_amd64.zip -O terraform-provider-${PROVIDER_NAME}.zip
if [ $? -ne 0 ]; then
    wget ${PROVIDER_GITHUB_URL}/releases/download/v${PROVIDER_VERSION}/terraform-provider-${PROVIDER_NAME}_v${PROVIDER_VERSION}_${ARCH}_amd64.zip -O terraform-provider-${PROVIDER_NAME}.zip
fi

unzip terraform-provider-${PROVIDER_NAME}.zip terraform-provider-${PROVIDER_NAME}_v${PROVIDER_VERSION}
if [ $? -ne 0 ]; then
    unzip terraform-provider-${PROVIDER_NAME}.zip terraform-provider-${PROVIDER_NAME}
    mv terraform-provider-${PROVIDER_NAME} ./terraform-bundle/plugins/
    mv ./terraform-bundle/plugins/terraform-provider-${PROVIDER_NAME} ./terraform-bundle/plugins/terraform-provider-${PROVIDER_NAME}_v${PROVIDER_VERSION}
    chmod +x ./terraform-bundle/plugins/terraform-provider-${PROVIDER_NAME}_v${PROVIDER_VERSION}
    rm terraform-provider-${PROVIDER_NAME}.zip
else
    mv terraform-provider-${PROVIDER_NAME}_v${PROVIDER_VERSION} ./terraform-bundle/plugins/
    chmod +x ./terraform-bundle/plugins/terraform-provider-${PROVIDER_NAME}_v${PROVIDER_VERSION}
    rm terraform-provider-${PROVIDER_NAME}.zip
fi
