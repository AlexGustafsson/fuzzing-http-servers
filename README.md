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
# Create patches from altered sources
make create-patches

# Apply patches again (done automatically by make init)
make apply-patches
```
