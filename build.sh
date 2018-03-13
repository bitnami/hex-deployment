#!/usr/bin/env bash

install_packages apt-transport-https

# Install Yarn
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
  install_packages yarn

# Cd into the correct folder
cd /app

# Install lerna
yarn global add lerna && yarn install

# Build the project
lerna bootstrap --scope @bitnami/hex-docs --npm-client=yarn
lerna run --scope @bitnami/hex-docs build
