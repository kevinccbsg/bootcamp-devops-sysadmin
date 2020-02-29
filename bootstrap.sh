#!/usr/bin/env bash

echo "Configure script"

ELK_VERSION="6.2.4"

# Install Java

## update apt
sudo apt-get update
sudo apt-get install -y unzip git apt-transport-https default-jre

java -version
echo "Java Home is"
echo $JAVA_HOME

# Elastic search
echo "Elastic Search scripts"

## Import elastic PGP key

wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -

## Installing from the APT repository
sudo apt-get install apt-transport-https
echo "deb https://artifacts.elastic.co/packages/6.x/apt stable main" | sudo tee -a /etc/apt/sources.list.d/elastic-6.x.list

sudo apt-get update && sudo apt-get install elasticsearch=$ELK_VERSION

## init elasticsearch

echo "Install elastic search"
cp /vagrant/elasticsearch/elasticsearch.yml /etc/elasticsearch/
sudo systemctl daemon-reload
sudo systemctl enable elasticsearch.service
sudo systemctl start elasticsearch.service

echo "Elasticsearch installed"

# Kibana search
echo "Install Kibana"

## update packages
sudo apt-get update && sudo apt-get install -y kibana=$ELK_VERSION

# init kibana
cp /vagrant/kibana/kibana.yml /etc/kibana/
sudo systemctl daemon-reload
sudo systemctl enable kibana.service
sudo systemctl start kibana.service

echo "Kibana installed"



