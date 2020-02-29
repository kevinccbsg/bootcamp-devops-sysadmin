#!/usr/bin/env bash

echo "Configure script"

# Elastic search

## Import elastic PGP key

wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -

## update packages
sudo apt-get update

## Installing from the APT repository
sudo apt-get install apt-transport-https
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-7.x.list

sudo apt-get update && sudo apt-get install elasticsearch

## init with systemd

cp /vagrant/elasticsearch/elasticsearch.yml /etc/elasticsearch/
sudo systemctl daemon-reload
sudo systemctl enable elasticsearch.service
sudo systemctl start elasticsearch.service
