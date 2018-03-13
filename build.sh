#!/usr/bin/env bash

install_packages apt-transport-https

# Install Yarn
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list && \
  install_packages yarn

# Cd into the correct folder
cd /app

# Install lerna
yarn global add lerna && yarn install

# Build the project
lerna run --scope @bitnami/hex-docs build
