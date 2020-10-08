# Disable echoing of commands
MAKEFLAGS += --silent

USE_AFL ?= 1

ifeq ($(USE_AFL),1)
BUILD_FLAGS := AFL_CC=gcc AFL_CXX=g++ AFL_HARDEN=1 CC=$(PWD)/sources/AFL/afl-gcc CXX=$(PWD)/sources/AFL/afl-g++ CPP=$(PWD)/sources/AFL/afl-g++
else
BUILD_FLAGS :=
endif

# Don't run in parallel
.NOTPARALLEL:

.PHONY: all build clean afl preeny

all: build

# Build sources
build: sources/aaron-kalair/server

init:
	git submodule update --init

afl:
	AFL_CC=gcc AFL_CXX=g++ $(MAKE) -C ./sources/AFL

preeny:
	$(MAKE) -C ./sources/preeny/src desock.so

sources/aaron-kalair/server:
	$(BUILD_FLAGS) $(MAKE) -C ./sources/aaron-kalair server

sources/wsic/build/wsic:
	# LD_PRELOAD="$(PWD)/sources/preeny/src/desock.so"
	$(BUILD_FLAGS) $(MAKE) -C ./sources/wsic build

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
	cd sources/wsic && git apply ../../patches/afl/wsic.patch &> /dev/null || true

apply-wfuzz-patches: remove-patches
	cd sources/aaron-kalair && git apply --ignore-space-change --ignore-whitespace ../../patches/wfuzz/aaron-kalair.patch || true
	cd sources/wsic && git apply --ignore-space-change --ignore-whitespace ../../patches/wfuzz/wsic.patch || true

remove-patches:
	cd sources/aaron-kalair && git add . && git stash &> /dev/null && git reset --hard HEAD &> /dev/null
	cd sources/wsic && git add . && git stash &> /dev/null && git reset --hard HEAD &> /dev/null

clean:
	rm sources/aaron-kalair/server &> /dev/null || true
	rm -r sources/wsic/build &> /dev/null || true
