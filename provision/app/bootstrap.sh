#!/usr/bin/env bash

echo "Configure app"

## Installing git
sudo apt install -y git-all

echo "smoke test git"
git --version

## Installing nvm
wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.2/install.sh | bash

cat ~/.bashrc
## Reload source env
. ~/.bashrc

## Installing node
nvm install node

echo "smoke test node"
node --version

## cloning repo
git clone --branch log-file https://github.com/kevinccbsg/web-bootcamp-exercise-beer-api.git

cd pwa-workbox-talk

## Installing dependencies
npm i

