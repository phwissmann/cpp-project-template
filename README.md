# A Modern C++ Project Setup
This repository contains an example project for C++ development. It is not meant to be exhaustive but gathers several useful tools in an initial setup.


Contributions are welcome.


## Dev Container
The project contains configuration for Visual Studio Code to use a development container <https://code.visualstudio.com/docs/devcontainers/containers>

The container contains several pre-requisites in order to build the project, see [install-prerequisites](./.devcontainer/install-prerequisites.sh). All the tools used in this repository will be available in this container.

## Conan
Conan is a dependency and package manager for C and C++ languages, <https://docs.conan.io/2/introduction.html>

### Dependencies
Dependencies can be added to the `conanfile.txt` <https://docs.conan.io/2/reference/conanfile_txt.html>
```toml
[requires]
onetbb/2021.3.0

[options]
onetbb/*:shared=True

[tool_requires]
cmake/3.28.1
ninja/1.11.1
```

and packages are by default fetched from Conan Center <https://conan.io/center>.

### Profiles
In order to define various settings of the required packages, profiles can be used. The example below requires a package built with clang-18, on Linux x86_64 with C++ 20 standard in Release.

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

See <https://docs.conan.io/2/reference/config_files/profiles.html> for details.

## CCache
Ccache (<https://ccache.dev>) is a compiler cache that speeds up recompilation of previously built compilation units. The local cache directory is set to `.ccache` and is mounted in the container such that it persists over restarts of the container. 

## Clang Format
ClangFormat allows to consistently format source. The exact style can be configured using a [.clang-format](/src/.clang-format) file in the source directory. For further information see <https://clang.llvm.org/docs/ClangFormat.html>.

VS Code can be configured to format on save using the same configuration.

<!-- standalone script -->

## Clang Tidy
> clang-tidy is a clang-based C++ “linter” tool. Its purpose is to provide an extensible framework for diagnosing and fixing typical programming errors, like style violations, interface misuse, or bugs that can be deduced via static analysis. 

The applied rules can be configured using a [.clang-tidy](/src/.clang-tidy) file in the source directory. For further information see <https://clang.llvm.org/extra/clang-tidy>


The setup in this repository includes a cache for clang tidy. 

```bash
dev@ubuntu22:/workspace$ ./run-clang-tidy.sh
```
<!-- cache -->

## Clangd
From <https://clangd.llvm.org>:
> clangd is a language server that can work with many editors via a plugin  <https://clangd.llvm.org>.
> 
> clangd runs the clang compiler on your code as you type, and shows diagnostics of errors and warnings in-place.
>
> clangd embeds clang-tidy which provides extra hints about code problems: bug-prone patterns, performance traps, and style issues.

<!-- settings.json -->

## Building using CMake

### 1. Install dependendencies with a specified profile while building packages that cannot be found locally or in the remotes.

```bash
dev@ubuntu22:/workspace$ conan install . --output-folder=build --profile=profiles/ubuntu-22.04.clang.release.conan-profile --build=missing
```

### 2. Configuring using `Ninja`, `clang` and the `conan`

```bash
dev@ubuntu22:/workspace$ cd build

dev@ubuntu22:/workspace/build$ cmake ../src -G Ninja -DCMAKE_TOOLCHAIN_FILE=conan_toolchain.cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_CXX_COMPILER=/usr/bin/clang++-18
```
> **Note:** Add '-DCCACHE=OFF' to disable the compiler cache. Default is `ON`.

### 3. Build, install and package

```bash
# build with 4 parallel jobs
dev@ubuntu22:/workspace/build$ cmake --build . -j 4
# installing the binaries, shared libraries and headers
dev@ubuntu22:/workspace/build$ cmake --install . --prefix=./install 
# Creates a PROJECTNAME-***.tar.gz with the binaries and libraries inside
dev@ubuntu22:/workspace/build$ cpack
``` 