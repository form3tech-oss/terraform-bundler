platform := $(shell uname)

TERRAFORM_VERSION ?= 0.11.14

default: clean build publish

clean:
	@bash -c "./scripts/clear.sh"

build:
	@bash -c "./scripts/build.sh linux $(TERRAFORM_VERSION)"

publish:
	@bash -c "./scripts/publish.sh $(TERRAFORM_VERSION)"

docker:
	@bash -c "./scripts/publish-docker.sh"

.PHONY: build publish clean
