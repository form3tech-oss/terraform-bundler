TERRAFORM_VERSION ?= 0.11.14

default: clean build publish docker

.PHONY: clean
clean:
	@bash -c "./scripts/clear.sh"

.PHONY: build
build:
	@bash -c "./scripts/build.sh linux $(TERRAFORM_VERSION)"

.PHONY: publish
publish:
	@bash -c "./scripts/publish.sh $(TERRAFORM_VERSION)"

.PHONY: check-tf-tag
check-tf-tag:
	 @: ${if ${TF_TAG},,${error TF_TAG is undefined}}

.PHONY: tf-bundle-build
tf-bundle-build: check-tf-tag
	@bash -c "./scripts/tf_bundle_build.sh $(TF_TAG)"

.PHONY: docker
docker:
	@bash -c "./scripts/publish-docker.sh $(TERRAFORM_VERSION)"

.PHONY: build publish docker clean
