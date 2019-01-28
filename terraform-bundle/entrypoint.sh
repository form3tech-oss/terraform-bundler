#!/usr/bin/env bash

mkdir plugins

envsubst < terraform-bundle.hcl.template > terraform-bundle.hcl

./install_terraform_provider.sh 'acme' $ACME_PROVIDER_VERSION 'https://github.com/paybyphone/terraform-provider-acme'
./install_terraform_provider.sh 'form3' $FORM3_PROVIDER_VERSION 'https://github.com/form3tech-oss/terraform-provider-form3'
./install_terraform_provider.sh 'kibana' $KIBANA_PROVIDER_VERSION 'https://github.com/ewilde/terraform-provider-kibana'
./install_terraform_provider.sh 'alienvault' "$ALIENVAULT_PROVIDER_VERSION" 'https://github.com/form3tech-oss/terraform-provider-alienvault'

./terraform-bundle package -os=linux -arch=amd64 terraform-bundle.hcl
mv terraform_*.zip /output
