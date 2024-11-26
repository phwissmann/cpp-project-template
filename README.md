# A Modern C++ Project Setup
This repository contains an example project for C++ development. It is not meant to be exhaustive but gathers several useful tools in an initial setup.


Contributions are welcome.


## Dev Container
The project contains configuration for Visual Studio Code to use a development container <https://code.visualstudio.com/docs/devcontainers/containers>

The container contains several pre-requisites in order to build the project, see [install-prerequisites](./.devcontainer/install-prerequisites.sh). All the tools used in this repository will be available in this container.

## Conan
Conan is a dependency and package manager for C and C++ languages, <https://docs.conan.io/2/introduction.html/>

### Dependencies
Dependencies can be added to the `conanfile.txt` <https://docs.conan.io/2/reference/conanfile_txt.html/>
```toml
[requires]
onetbb/2021.3.0

[options]
onetbb/*:shared=True

[tool_requires]
cmake/3.28.1
ninja/1.11.1
```

and packages are by default fetched from Conan Center <https://conan.io/center/>.

### Profiles
In order to define various settings of the required packages, profiles can be used:

```toml
[buildenv]
CC=/usr/bin/clang-18
CXX=/usr/bin/clang++-18


[settings]
arch=x86_64
compiler=clang
compiler.cppstd=20
compiler.libcxx=libstdc++
compiler.version=18
os=Linux
build_type=Release
```
See <https://docs.conan.io/2/reference/config_files/profiles.html/> for details.

## CCache
Ccache (<https://ccache.dev>) is a compiler cache that speeds up recompilation of previously built compilation units. The local cache directory is set to `.ccache` and is mounted in the container such that it persists over restarts of the container. 

## Clang Format

## Clang Tidy

## Clangd

## Building using CMake
```bash

dev@ubuntu22:/workspace/build$ conan install . --output-folder=build --profile=profiles/ubuntu-22.04.clang.release.conan-profile --build=missing

dev@ubuntu22:/workspace/build$ cd build

dev@ubuntu22:/workspace/build$ cmake ../src -G Ninja -DCMAKE_TOOLCHAIN_FILE=conan_toolchain.cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_COMPILER=/usr/bin/clang++-18
```
> **Note:** Add '-DCCACHE=OFF' to disable the compiler cache

```bash
# build with 4 parallel jobs
dev@ubuntu22:/workspace/build$ cmake --build . -j 4
# installing the binaries, shared libraries and headers
dev@ubuntu22:/workspace/build$ cmake --install . --prefix=./install 
# Creates a PROJECTNAME-***.tar.gz with the binaries and libraries inside
dev@ubuntu22:/workspace/build$ cpack
``` 