platform := $(shell uname)
acme_version := "0.6.0"
form3_version := "0.19.1"

clear:
	@bash -c "rm output/*"
	@bash -c "rm terraform-bundle/plugins/terraform-provider-*"

ifeq (${platform},Darwin)
install-third-party-tools:
	@brew list wget &>/dev/null || brew install wget
	@mkdir -p ./terraform-bundle/plugins/
	@bash -c "./install_terraform_provider.sh 'acme' ${acme_version} 'https://github.com/paybyphone/terraform-provider-acme'"
	@bash -c "./install_terraform_provider.sh 'form3' ${form3_version} 'https://github.com/form3tech-oss/terraform-provider-form3'"
else
install-third-party-tools:
	@mkdir -p ./terraform-bundle/plugins/
	@bash -c "./install_terraform_provider.sh 'acme' ${acme_version} 'https://github.com/paybyphone/terraform-provider-acme'"
	@bash -c "./install_terraform_provider.sh 'form3' ${form3_version} 'https://github.com/form3tech-oss/terraform-provider-form3'"
endif

.PHONY: install-third-party-tools
