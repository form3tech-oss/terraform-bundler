platform := $(shell uname)

default: clean build publish

clean:
	@bash -c "./scripts/clear.sh"

build:
	@bash -c "./scripts/build.sh linux"

publish:
	@bash -c "./scripts/publish.sh"

.PHONY: build publish clean
