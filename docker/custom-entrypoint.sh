#!/usr/bin/dumb-init /bin/sh
set -e

: ${SLEEP_LENGTH:=2}
: ${TIMEOUT_LENGTH:=300}

create_terraform_configuration() {

    if [ -d "terraform-working-dir" ]; then rm -Rf terraform-working-dir; fi
    mkdir terraform-working-dir

    cp -R tf/* terraform-working-dir/
    cp -R tf_test_overrides/* terraform-working-dir/

    find ./terraform-working-dir/ -name '*.aws.tf' -o -name '*.tfvars' -o -name '*.sh' -o -name '*file' -o -name 'state.tf' | xargs -r rm
}

create_terraform_configuration

cd terraform-working-dir

envsubst '\$TFE_TOKEN' < /tmp/terraformrc.template > ~/.terraformrc
terraform init
terraform apply -auto-approve -no-color
