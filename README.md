## Quick Start

### Preparation

Linux is required for AFL fuzzing. Tested on a minimal Ubuntu 20.04.1 desktop installation.

Requirements:

* git
* gcc
* make
* bash
* pip
* wfuzz
* libcurl4-openssl-dev
* libssl-dev
* python3-pip
* libini-config-dev
* libseccomp-dev

These can be installed on said Ubuntu by running:

```
sudo apt update && apt install build-essential git python3-pip libcurl4-openssl-dev libssl-dev libini-config-dev libseccomp-dev && sudo python3 -m pip install wfuzz
```

On Ubuntu you'll also need to do the following to use AFL:

```bash
sudo -i
echo core > /proc/sys/kernel/core_pattern
```

### Cloning the code

```bash
# Fetch the project
git clone https://github.com/AlexGustafsson/fuzzing-http-servers
# Enter the project
cd fuzzing-http-servers
# Initialize submodules
make init
```

### Fuzzing with AFL

Build AFL.

```bash
make afl
```

Apply the correct patches.

```bash
make apply-afl-patches
```

Build one of the servers.

```bash
make sources/aaron-kalair/server
```

Start fuzzing.

```bash
# The first parameter is the binary to fuzz, any further parameters are used as parameters for the binary itself
./afl.sh sources/aaron-kalair/server
```

### Fuzzing with WFuzz

Apply the correct patches.

```bash
make apply-wfuzz-patches
```

Build one of the servers.

```bash
make USE_AFL=0 sources/aaron-kalair/server
```

Start fuzzing.

### Creating, applying and removing patches

When patching the servers for use with either of the tools, the code might have to be altered. These commands help aid you.

```bash
# Create patches from altered sources
make create-afl-patches
make create-wfuzz-patches

# Apply patches
make apply-afl-patches
make apply-wfuzz-patches

# Remove patches (warning: performs a hard reset on the repositories!)
make remove-patches
```
