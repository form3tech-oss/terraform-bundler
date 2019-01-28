platform := $(shell uname)

default: clear build publish

clear:
	@bash -c "./scripts/clear.sh"

build:
	@bash -c "./scripts/build.sh"

publish:
	@bash -c "./scripts/publish.sh"

.PHONY: build publish clear
