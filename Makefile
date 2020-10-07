# Disable echoing of commands
MAKEFLAGS += --silent

.PHONY: all build clean

all: build

# Build sources
build: sources/aaron-kalair/server

init:
	git submodule init sources/aaron-kalair sources/soywood sources/wasmerio sources/wsic sources/AFL
	$(MAKE) apply-patches

sources/AFL/afl-g++:
	AFL_CC=gcc AFL_CXX=g++ $(MAKE) -C ./sources/AFL afl-g++

sources/AFL/afl-gcc:
	AFL_CC=gcc AFL_CXX=g++ $(MAKE) -C ./sources/AFL afl-gcc

sources/aaron-kalair/server: sources/AFL/afl-gcc
	AFL_CC=gcc AFL_CXX=g++ AFL_HARDEN=1 CC=$(PWD)/sources/AFL/afl-gcc $(MAKE) -C ./sources/aaron-kalair server

apply-patches:
	cd sources/aaron-kalair && git apply --stat ../../patches/aaron-kalair.patch || true
	cd sources/soywood && git apply --stat ../../patches/soywood.patch || true
	cd sources/wasmerio && git apply --stat ../../patches/wasmerio-kalair.patch || true
	cd sources/wsic && git apply --stat ../../patches/wsic.patch || true

create-patches:
	cd sources/aaron-kalair && git diff > ../../patches/aaron-kalair.patch || true
	cd sources/soywood && git diff > ../../patches/soywood.patch || true
	cd sources/wasmerio && git diff > ../../patches/wasmerio-kalair.patch || true
	cd sources/wsic && git diff > ../../patches/wsic.patch || true

clean:
	rm -rf ./sources/*/build
