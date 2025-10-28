# syntax=docker/dockerfile:1

######
# Docker create & run command to create the container
# CWD: this git repo
# docker build -t threejs-demo .
# docker run --rm -it --mount "type=bind,src=$(realpath .),dst=/home/me" threejs-demo
######

FROM ubuntu:latest@sha256:66460d557b25769b102175144d538d88219c077c678a49af4afca6fbfc1b5252
LABEL org.opencontainers.image.authors="kayhadrin@gmail.com"

# ARG DEBIAN_FRONTEND=noninteractive
# TODO: remove unnecessary packages below

# Perf monitoring tools
RUN apt-get update && apt-get install -y \
  atop \
  htop \
  iotop \
  lsof

# Network tools
RUN apt-get update && apt-get install -y \
  curl \
  dnsutils \
  iftop \
  inetutils-ping \
  net-tools

# Admin tools
RUN apt-get update && apt-get install -y \
  openssh-server \
  sudo

# General utils
RUN apt-get update && apt-get install -y \
  bzip2 \
  git-absorb \
  screen \
  tzdata \
  unzip \
  vim

# Add GitHub gh CLI apt sources
RUN (type -p wget >/dev/null || (apt update && apt install wget -y)) \
  && mkdir -p -m 755 /etc/apt/keyrings \
  && out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg \
  && cat $out | tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
  && chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
  && mkdir -p -m 755 /etc/apt/sources.list.d \
  && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
  | tee /etc/apt/sources.list.d/github-cli.list > /dev/null

# Add Stacked Pull Requests (SPR) apt sources
RUN echo "deb [trusted=yes] https://apt.fury.io/inigolabs/ /" \
  | tee /etc/apt/sources.list.d/inigolabs.list

# Development tools
RUN apt-get update && apt-get install -y \
  bash-completion \
  build-essential \
  gh \
  git \
  git-core  \
  graphviz \
  libssl-dev \
  make \
  pkg-config \
  spr

# Customize this in the .env.docker file if needed
ENV LANG=en_US.utf8
ENV TZ=/UTC

# Set timezone config
RUN echo "$TZ" > /etc/timezone
RUN dpkg-reconfigure -f noninteractive tzdata

# TODO: remove sudo privileges once we know what we eventually need at runtime
RUN echo 'ubuntu ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# ARG USERNAME
# ARG UID=1000
# ARG GID=1000
# RUN groupadd -g $GID $USERNAME -o || true
# RUN useradd -u $UID -o -g $GID -c "Docker user" -m -d /home -G sudo -s /bin/bash $USERNAME

# RUN useradd -c "Docker user" -m -d /home/me -G sudo -s /bin/bash me

# TODO: remove this? Only useful for root user during debugging
RUN cp /home/ubuntu/.bashrc /root/.bashrc

USER ubuntu
WORKDIR /home/ubuntu
ENV HOME=/home/ubuntu

##################
# Install nvm
##################
# Use bash for the shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# Create a script file sourced by both interactive and non-interactive bash shells
ENV BASH_ENV=${HOME}/.bash_env
RUN touch "${BASH_ENV}"
RUN echo '. "${BASH_ENV}"' >> ~/.bashrc
# Download and install nvm
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh \
  | PROFILE="${BASH_ENV}" bash

# Copy host's git repo to the volume
RUN mkdir app
RUN cat /etc/group | grep ubuntu
COPY --link \
  --chown=1000:1000 \
  ./ ./app/
RUN chown -R ubuntu:ubuntu ./app

# Use node version as per the .nvmrc file
RUN nvm install $(cat ~/app/.nvmrc)
RUN nvm use $(cat ~/app/.nvmrc)
RUN npm install -g corepack@latest
# The node package manager will be installed by setup.sh

# Setup bash and other CLI tools
RUN ./app/.devcontainer/cli_helpers/setup.sh
RUN ./app/.devcontainer/cli_helpers/setup_git_config.sh

# No entry point needed, VS Code will add its own automatically
# ENTRYPOINT ["/bin/bash", "-l", "-c", "cd $HOME/app && bash -l"]
