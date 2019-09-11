platform := $(shell uname)

TERRAFORM_VERSION ?= v0.11.14

default: clean build publish

clean:
	@bash -c "./scripts/clear.sh"

build:
	@bash -c "./scripts/build.sh linux $(TERRAFORM_VERSION)"

publish:
	@bash -c "./scripts/publish.sh"

.PHONY: build publish clean
