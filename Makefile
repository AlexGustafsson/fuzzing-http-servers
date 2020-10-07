# Disable echoing of commands
MAKEFLAGS += --silent

USE_AFL ?= 1

ifeq ($(USE_AFL),1)
BUILD_FLAGS := AFL_CC=gcc AFL_CXX=g++ AFL_HARDEN=1 CC=$(PWD)/sources/AFL/afl-gcc CXX=$(PWD)/sources/AFL/afl-g++ CPP=$(PWD)/sources/AFL/afl-g++
else
BUILD_FLAGS :=
endif

.PHONY: all build clean

all: build

# Build sources
build: sources/aaron-kalair/server

init:
	git submodule init sources/aaron-kalair sources/soywood sources/wasmerio sources/wsic sources/AFL

sources/AFL/afl-g++:
	AFL_CC=gcc AFL_CXX=g++ $(MAKE) -C ./sources/AFL afl-g++

sources/AFL/afl-gcc:
	AFL_CC=gcc AFL_CXX=g++ $(MAKE) -C ./sources/AFL afl-gcc

sources/aaron-kalair/server: sources/AFL/afl-gcc
	$(BUILD_FLAGS) $(MAKE) -C ./sources/aaron-kalair server

create-afl-patches:
	mkdir -p patches/afl
	cd sources/aaron-kalair && git add . && git diff --cached --binary > ../../patches/afl/aaron-kalair.patch || true
	cd sources/soywood && git add . && git diff --cached --binary > ../../patches/afl/soywood.patch || true
	cd sources/wasmerio && git add . && git diff --cached --binary > ../../patches/afl/wasmerio-kalair.patch || true
	cd sources/wsic && git add . && git diff --cached --binary > ../../patches/afl/wsic.patch || true

create-wfuzz-patches:
	mkdir -p patches/wfuzz
	cd sources/aaron-kalair && git add . && git diff --cached --binary > ../../patches/wfuzz/aaron-kalair.patch || true
	cd sources/soywood && git add . && git diff --cached --binary > ../../patches/wfuzz/soywood.patch || true
	cd sources/wasmerio && git add . && git diff --cached --binary > ../../patches/wfuzz/wasmerio-kalair.patch || true
	cd sources/wsic && git add . && git diff --cached --binary > ../../patches/wfuzz/wsic.patch || true

apply-afl-patches: remove-patches
	cd sources/aaron-kalair && git apply ../../patches/afl/aaron-kalair.patch &> /dev/null || true
	cd sources/soywood && git apply ../../patches/afl/soywood.patch &> /dev/null  || true
	cd sources/wasmerio && git apply ../../patches/afl/wasmerio-kalair.patch &> /dev/null  || true
	cd sources/wsic && git apply ../../patches/afl/wsic.patch &> /dev/null  || true

apply-wfuzz-patches: remove-patches
	cd sources/aaron-kalair && git apply ../../patches/wfuzz/aaron-kalair.patch &> /dev/null || true
	cd sources/soywood && git apply ../../patches/wfuzz/soywood.patch &> /dev/null  || true
	cd sources/wasmerio && git apply ../../patches/wfuzz/wasmerio-kalair.patch &> /dev/null  || true
	cd sources/wsic && git apply ../../patches/wfuzz/wsic.patch &> /dev/null  || true

remove-patches:
	cd sources/aaron-kalair && git add . && git stash  &> /dev/null && git reset --hard HEAD &> /dev/null
	cd sources/soywood && git add . && git stash  &> /dev/null && git reset --hard HEAD &> /dev/null
	cd sources/wasmerio && git add . && git stash  &> /dev/null && git reset --hard HEAD &> /dev/null
	cd sources/wsic && git add . && git stash  &> /dev/null && git reset --hard HEAD &> /dev/null

clean:
	rm sources/aaron-kalair/server &> /dev/null || true
