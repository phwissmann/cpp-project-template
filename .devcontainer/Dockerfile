FROM ubuntu:22.04 AS build

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y && apt-get upgrade -y

RUN apt-get update -y && apt-get install -y \
  sudo 

# User configuration
ARG USERNAME
ARG UID=1000
ARG GID=1000

RUN groupadd -r -g ${GID} ${USERNAME} && \
  useradd -u ${UID} -g ${GID} -m -G sudo -s /bin/bash ${USERNAME} && \
  echo "${USERNAME}:${USERNAME}" | chpasswd && \
  echo "${USERNAME} ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/${USERNAME} && \
  chmod 440 /etc/sudoers.d/${USERNAME}

ARG CMAKE_VERSION
ARG CONAN_VERSION
ARG LLVM_VERSION
ARG MOLD_VERSION 
ARG VALGRIND_VERSION

COPY ./install-prerequisites.sh ./
RUN chmod +x install-prerequisites.sh
RUN ./install-prerequisites.sh

# Conan user config
USER ${USERNAME}
RUN conan profile detect --force
RUN echo "core.cache:storage_path=/workspace/.conan" >> /home/${USERNAME}/.conan2/global.conf


