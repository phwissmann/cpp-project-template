# Modern C++ Project Setup
This repository contains an example project for C++ development.


## Dev Container

## Conan

## CCache - Compiler Cache

## Clang Format

## Clang Tidy

## Clangd

## Building using CMake
```bash

dev@ubuntu22:/workspace/build$ conan install . --output-folder=build --profile=profiles/ubuntu-22.04.clang.release.conan-profile --build=missing

dev@ubuntu22:/workspace/build$ cd build

dev@ubuntu22:/workspace/build$ cmake ../src -G Ninja -DCMAKE_TOOLCHAIN_FILE=conan_toolchain.cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_COMPILER=/usr/bin/clang++-18

> **Note:** Add '-DCCACHE=OFF' to disable the compiler cache

 # build with 4 parallel jobs
dev@ubuntu22:/workspace/build$ cmake --build . -j 4
# installing the binaries, shared libraries and headers
dev@ubuntu22:/workspace/build$ cmake --install . --prefix=./install 
# Creates a PROJECTNAME-***.tar.gz with the binaries and libraries inside. Doesn't require building or installing beforehand.
dev@ubuntu22:/workspace/build$ cpack
``` 

# Valgrind