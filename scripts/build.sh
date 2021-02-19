#!/usr/bin/env bash
REPO_WORK_DIR="$(git rev-parse --show-toplevel)"
TARGET_PLATFORM=$1
TERRAFORM_VERSION=$2
form3_bundle_json="$(cat $REPO_WORK_DIR/form3-bundle-${TERRAFORM_VERSION}.json)"
build_dir=$REPO_WORK_DIR/build
plugins_dir=$REPO_WORK_DIR/build/plugins
scripts_dir=$REPO_WORK_DIR/scripts
uname_str=$(uname)
if [ $uname_str = "Darwin" ]; then
    RUNNING_PLATFORM="darwin"
else
    RUNNING_PLATFORM="linux"
fi


function prepareBuildDirectory() {
    if ls $build_dir 1> /dev/null 2>&1; then
        rm -rf $build_dir
    fi
    mkdir $build_dir
}


function preparePluginsDirectory() {
    if ls $plugins_dir 1> /dev/null 2>&1; then
        rm -rf $plugins_dir
    fi
    mkdir $plugins_dir
}

function generateTerraformBundleHcl() {
    # Clean up file if exists
    cat /dev/null > $build_dir/terraform-bundle.hcl

    # Add terraform block
    cat >>$build_dir/terraform-bundle.hcl <<CONFIG
terraform {
  # Version of Terraform to include in the bundle. An exact version number
  # is required.
  version = "$TERRAFORM_VERSION"
}
CONFIG

    # Add providers block
    echo "providers {" >> $build_dir/terraform-bundle.hcl

    echo $form3_bundle_json | jq -c -r '.providers[]' | while read provider ; do
        provider_name=$(echo $provider | jq -r '.name')
        provider_version=$(echo $provider | jq -r '.version')

        cat >>$build_dir/terraform-bundle.hcl <<CONFIG
  $provider_name = ["~> $provider_version"]
CONFIG

    done

    # Close providers section
    echo "}" >> $build_dir/terraform-bundle.hcl

}

function downloadProviders() {
    echo $form3_bundle_json | jq -c -r '.providers[]' | while read provider ; do
        provider_name=$(echo $provider | jq -r '.name')
        provider_version=$(echo $provider | jq -r '.version')
        provider_url=$(echo $provider | jq -r '.url')
        $scripts_dir/install_terraform_provider.sh $provider_name $provider_version $provider_url $RUNNING_PLATFORM $TARGET_PLATFORM
    done
}

function buildTerraformBundle() {
    pushd $build_dir
    $REPO_WORK_DIR/bin/terraform-bundle-${TERRAFORM_VERSION}_${RUNNING_PLATFORM}_amd64 package -os=$TARGET_PLATFORM -arch=amd64 $build_dir/terraform-bundle.hcl
    popd
}

prepareBuildDirectory
preparePluginsDirectory
downloadProviders
generateTerraformBundleHcl
buildTerraformBundle


