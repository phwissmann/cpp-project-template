#!/bin/bash

# exit on error
set -e 

apt-get update -y && apt-get install -y \
    git \
    vim \
    wget \
    curl \
    g++-11 \
    ninja-build \
    gfortran-11 \
    ccache \
    lldb \
    lcov \
    libc6-dbg \
    lsb-release \
    python3-pip \
    software-properties-common \
    gnupg

# Clang 18
wget https://apt.llvm.org/llvm.sh && chmod +x llvm.sh
./llvm.sh ${LLVM_VERSION} all

wget https://github.com/rui314/mold/releases/download/v${MOLD_VERSION}/mold-${MOLD_VERSION}-x86_64-linux.tar.gz && tar -xzf mold-${MOLD_VERSION}-x86_64-linux.tar.gz
cp -r mold-${MOLD_VERSION}-x86_64-linux/* /usr/local/

# Valgrind
wget https://sourceware.org/pub/valgrind/valgrind-${VALGRIND_VERSION}.tar.bz2 && tar -xjf valgrind-${VALGRIND_VERSION}.tar.bz2 && \
    cd valgrind-${VALGRIND_VERSION} && \
    ./configure --prefix=/usr/local && \
    make -j4 && \
    sudo make install && \
    rm -rf valgrind*

# Cmake
wget https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}-linux-x86_64.sh
chmod +x cmake-${CMAKE_VERSION}-linux-x86_64.sh
mkdir /home/${USERNAME}/cmake

./cmake-${CMAKE_VERSION}-linux-x86_64.sh --skip-license --prefix=/usr/local --exclude-subdir

# Conan
pip3 install conan==${CONAN_VERSION}
ln -s ~/.local/bin/conan /usr/bin/conan

# Documentation
apt-get install doxygen -y
pip3 install mkdocs mkdocs-get-deps mkdocs-material mkdocs-material-extensions mkdoxy markdown-include