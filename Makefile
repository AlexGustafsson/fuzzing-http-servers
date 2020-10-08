# Disable echoing of commands
MAKEFLAGS += --silent

USE_AFL ?= 1

ifeq ($(USE_AFL),1)
BUILD_FLAGS := AFL_CC=gcc AFL_CXX=g++ AFL_HARDEN=1 CC=$(PWD)/sources/AFL/afl-gcc CXX=$(PWD)/sources/AFL/afl-g++ CPP=$(PWD)/sources/AFL/afl-g++
else
BUILD_FLAGS :=
endif

.PHONY: all build clean afl

all: build

# Build sources
build: sources/aaron-kalair/server

init:
	git submodule update --init

afl:
	AFL_CC=gcc AFL_CXX=g++ $(MAKE) -C ./sources/AFL

sources/aaron-kalair/server:
	$(BUILD_FLAGS) $(MAKE) -C ./sources/aaron-kalair server

sources/wsic/build/wsic:
	$(BUILD_FLAGS) $(MAKE) -C ./sources/wsic build

sources/preeny/Linux_x86_64/desock.so:
	$(MAKE) -C ./sources/preeny

create-afl-patches:
	mkdir -p patches/afl
	cd sources/aaron-kalair && git add . && git diff --cached --binary > ../../patches/afl/aaron-kalair.patch || true
	cd sources/wsic && git add . && git diff --cached --binary > ../../patches/afl/wsic.patch || true

create-wfuzz-patches:
	mkdir -p patches/wfuzz
	cd sources/aaron-kalair && git add . && git diff --cached --binary > ../../patches/wfuzz/aaron-kalair.patch || true
	cd sources/wsic && git add . && git diff --cached --binary > ../../patches/wfuzz/wsic.patch || true

apply-afl-patches: remove-patches
	cd sources/aaron-kalair && git apply ../../patches/afl/aaron-kalair.patch &> /dev/null || true
	cd sources/wsic && git apply ../../patches/afl/wsic.patch &> /dev/null  || true

apply-wfuzz-patches: remove-patches
	cd sources/aaron-kalair && git apply ../../patches/wfuzz/aaron-kalair.patch &> /dev/null || true
	cd sources/wsic && git apply ../../patches/wfuzz/wsic.patch &> /dev/null  || true

remove-patches:
	cd sources/aaron-kalair && git add . && git stash  &> /dev/null && git reset --hard HEAD &> /dev/null
	cd sources/wsic && git add . && git stash  &> /dev/null && git reset --hard HEAD &> /dev/null

clean:
	rm sources/aaron-kalair/server &> /dev/null || true
	rm -r sources/wsic/build &> /dev/null || true
