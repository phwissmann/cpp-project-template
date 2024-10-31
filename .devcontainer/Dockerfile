FROM ubuntu:22.04 as build

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -y && apt-get upgrade -y

RUN apt-get update -y \
  && apt-get install -y \
  sudo \
  git \
  vim \
  wget \
  g++ \
  clangd \
  python3-pip \ 
  ninja-build \
  clang-format \
  clang-tools \ 
  curl \
  gfortran \ 
  ccache \
  lldb \
  valgrind \
  lcov \
  mold

ARG USERNAME=dev
ARG UID=1000
ARG GID=1000
ARG CMAKE_VERSION=3.28.1
ARG CONAN_VERSION=2.1.0

RUN groupadd -r -g ${GID} ${USERNAME} && \
  useradd -u ${UID} -g ${GID} -m -G sudo -s /bin/bash ${USERNAME} && \
  echo "${USERNAME}:${USERNAME}" | chpasswd && \
  echo "${USERNAME} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${USERNAME} && \
  chmod 440 /etc/sudoers.d/${USERNAME}



RUN wget https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}-linux-x86_64.sh
RUN chmod +x cmake-${CMAKE_VERSION}-linux-x86_64.sh
RUN mkdir /home/${USERNAME}/cmake

RUN ./cmake-${CMAKE_VERSION}-linux-x86_64.sh --skip-license --prefix=/usr/local --exclude-subdir

RUN pip3 install conan==${CONAN_VERSION}
RUN ln -s ~/.local/bin/conan /usr/bin/conan


USER ${USERNAME}
RUN conan profile detect --force
RUN echo "core.cache:storage_path=/workspace/.conan" >> /home/${USERNAME}/.conan2/global.conf

