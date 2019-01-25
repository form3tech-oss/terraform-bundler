#!/usr/bin/env bash

./terraform-bundle package -os=linux -arch=amd64 terraform-bundle.hcl
mv terraform_*.zip /output
