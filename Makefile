# Disable echoing of commands
MAKEFLAGS += --silent

.PHONY: all build clean

all: build

# Build sources
build: sources/aaron-kalair/server

sources/aaron-kalair/server:
	$(MAKE) ./sources/aaron-kalair/makefile server

clean:
	rm -rf ./sources/*/build
