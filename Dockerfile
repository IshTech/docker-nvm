FROM ubuntu:22.04

LABEL name="nvm"

# Set the SHELL to bash with pipefail option
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Prevent dialog during apt install
ENV DEBIAN_FRONTEND noninteractive

# Install apt packages
RUN apt-get update -y
RUN apt-get install -y wget

# Add user "nvm" as non-root user
RUN useradd -ms /bin/bash nvm

# Copy and set permission for nvm directory
RUN mkdir -p /home/nvm/.nvm
RUN chown nvm:nvm -R "/home/nvm/.nvm"

# Set sudoer for "nvm"
RUN echo 'nvm ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

# Switch to user "nvm" from now
USER nvm

# Download install script
ARG NVM_VERSION=v0.39.7
RUN wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh | bash

# Install latest stable nodejs
ARG NVM_DIR=/home/nvm/.nvm
RUN source $NVM_DIR/nvm.sh && nvm install stable && nvm install --lts && nvm alias node lts/* && nvm alias default lts/*

# Set WORKDIR to nvm directory
WORKDIR /home/nvm/

ENTRYPOINT ["/bin/bash"]
