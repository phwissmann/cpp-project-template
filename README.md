# cpp-project-template
A project template for modern cpp development

## Build instructions
```bash

conan install ./src --output-folder=build --profile=profiles/ubuntu-22.04.gcc.release.conan-profile

cmake ../src -G Ninja -DCMAKE_TOOLCHAIN_FILE=conan_toolchain.cmake -DCMAKE_BUILD_TYPE=Release

 # build with 4 parallel jobs
cmake --build . -j 4
# installing the binaries, shared libraries and headers
cmake --install . --prefix=./install 
# Creates a JIXIE-***.tar.gz with the binaries and libraries inside. Doesn't require building or installing beforehand.
cmake --build . -j 4 --target package 
``` 