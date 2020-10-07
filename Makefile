# Disable echoing of commands
MAKEFLAGS += --silent

.PHONY: all build clean

all: build

# Build sources
build: sources/aaron-kalair/server

sources/aaron-kalair/server:
	$(MAKE) ./sources/aaron-kalair/makefile server

init:
	git submodule init sources/aaron-kalair sources/soywood sources/wasmerio sources/wsic
	$(MAKE) apply-patches

apply-patches:
	cd sources/aaron-kalair && git apply --stat ../../patches/aaron-kalair.patch || true
	cd sources/soywood && git apply --stat ../../patches/soywood.patch || true
	cd sources/wasmerio && git apply --stat ../../patches/aaroin-kalair.patch || true
	cd sources/wsic && git apply --stat ../../patches/wsic.patch || true

create-patches:
	cd sources/aaron-kalair && git diff > ../../patches/aaron-kalair.patch || true
	cd sources/soywood && git diff > ../../patches/soywood.patch || true
	cd sources/wasmerio && git diff > ../../patches/aaroin-kalair.patch || true
	cd sources/wsic && git diff > ../../patches/wsic.patch || true

clean:
	rm -rf ./sources/*/build
