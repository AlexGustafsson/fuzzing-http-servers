To get started:

```bash
# Fetch the project
git clone https://github.com/AlexGustafsson/fuzzing-http-servers
# Enter the project
cd fuzzing-http-servers
# Initialize submodules
make init
```

Other commands:
```bash
# Build AFL
make afl

# Create patches from altered sources
make create-afl-patches
make create-wfuzz-patches

# Apply patches
make apply-afl-patches
make apply-wfuzz-patches

# Remove patches (warning: performs a hard reset on the repositories!)
make remove-patches
```

Fuzzing using AFL:
```bash
# Apply the patches
make apply-afl-patches
# Build a server
make sources/aaron-kalair/server
# The first parameter is the binary to fuzz, any further parameters are used as parameters for the binary itself
./afl.sh sources/aaron-kalair/server
```

Fuzzing using WFuzz:
```bash
# Make sure that the binaries are unpatched
make apply-wfuzz-patches
# Build a server
make USE_AFL=0 sources/aaron-kalair/server
# ...
```
