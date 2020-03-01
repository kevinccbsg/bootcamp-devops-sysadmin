#!/usr/bin/env bash

echo "Configure app"

## Installing git
sudo apt-get update
sudo apt install -y git-all

echo "smoke test git"
git --version


## Installing node
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt-get install -y nodejs

echo "smoke test node"
node --version


## cloning repo
git clone --branch log-file https://github.com/kevinccbsg/web-bootcamp-exercise-beer-api.git

cd web-bootcamp-exercise-beer-api

## Installing dependencies
npm i

export DB_URL=mongodb://localhost:27017/beerapi

## load beer info
npm run loadData

# run app with systemctl
sudo systemctl enable nodeserver.service
sudo systemctl start nodeserver.service
