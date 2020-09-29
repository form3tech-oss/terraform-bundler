#!/usr/bin/dumb-init /bin/sh
set -e

: ${SLEEP_LENGTH:=2}
: ${TIMEOUT_LENGTH:=300}

create_terraform_configuration() {

    if [ -d "api-indoor-configuration" ]; then rm -Rf api-indoor-configuration; fi
    mkdir api-indoor-configuration

    cp -R tf/* api-indoor-configuration/
    cp -R tf_local_overrides/* api-indoor-configuration/

    find ./api-indoor-configuration/ -name '*.aws.tf' -o -name '*.tfvars' -o -name '*.sh' -o -name '*file' -o -name 'state.tf' | xargs rm
}

wait_for_postgres() {
	START=$(date +%s)
	echo "Waiting for postgresql at $1 to start on $2…"
	while ! pg_isready -h $1 -p $2;
	do
		if [ $(($(date +%s) - $START)) -gt $TIMEOUT_LENGTH ]; then
			echo "Postgres $1:$2 did not start within $TIMEOUT_LENGTH seconds. Aborting..."
			exit 1
		fi
		echo "sleeping while postgres starts"
		sleep $SLEEP_LENGTH
	done
}

wait_for_vault() {
	START=$(date +%s)
	echo "Waiting for vault at $1 to start…"
	while ! curl -sSf $1/v1/sys/health
	do
		if [ $(($(date +%s) - $START)) -gt $TIMEOUT_LENGTH ]; then
			echo "Vault did not start within $TIMEOUT_LENGTH seconds. Aborting..."
			exit 1
		fi
		echo "sleeping while vault starts"
		sleep $SLEEP_LENGTH
	done
}

create_terraform_configuration
#wait_for_postgres $TF_VAR_psql_host $TF_VAR_psql_port
#wait_for_vault $TF_VAR_api_vault_address

cd api-indoor-configuration

envsubst '\$TFE_TOKEN' < /tmp/terraformrc.template > ~/.terraformrc
terraform init
terraform apply -auto-approve -no-color
