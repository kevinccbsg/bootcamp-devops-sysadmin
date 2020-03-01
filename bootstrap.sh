#!/usr/bin/env bash

echo "Configure script"

ELK_VERSION="6.2.4"

# Disk management

## We define 2 disks in the vagrant file

## Partition sdc disk
(
echo n # Add a new partition
echo p # Primary partition
echo 1 # Partition number
echo   # First sector (Accept default: 1)
echo   # Last sector (Accept default: varies)
echo w # Write changes
) | sudo fdisk /dev/sdc
sudo mkfs.ext4 /dev/sdc1
## Partition sdd disk
(
echo n # Add a new partition
echo p # Primary partition
echo 1 # Partition number
echo   # First sector (Accept default: 1)
echo   # Last sector (Accept default: varies)
echo w # Write changes
) | sudo fdisk /dev/sdd
sudo mkfs.ext4 /dev/sdd1
## adding to fstab
# echo "/dev/sdc1  /var/lib/elasticsearch  ext4  defaults  0 0" >> /etc/fstab
# echo "/dev/sdd1  /var/lib/mongodb  ext4  defaults  0 0" >> /etc/fstab

# cat /etc/fstab

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


echo "Logstash install"

# Install logstash
sudo apt-get update && sudo apt-get install logstash

# copy over configs
cp -R /vagrant/logstash/* /etc/logstash/conf.d/
sudo systemctl enable logstash.service
sudo systemctl start logstash.service

echo "Install filebeat"
curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-$ELK_VERSION-amd64.deb
sudo dpkg -i filebeat-$ELK_VERSION-amd64.deb

# copy over configs
cp -R /vagrant/filebeat/filebeat.yml /etc/filebeat/
sudo systemctl enable filebeat.service
sudo systemctl start filebeat.service

echo "Setup permission for app logs"
# Setup permission for app logs
sudo touch /var/log/node-app.log
sudo chgrp vagrant /var/log/node-app.log
sudo chown vagrant /var/log/node-app.log

# # Install mongodb
echo "MongoDB install"
wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | sudo apt-key add -
sudo apt-get install -y gnupg

wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | sudo apt-key add -

echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.2.list

sudo apt-get update
sudo apt-get install -y mongodb-org

## Running mongodb
sudo systemctl daemon-reload
sudo systemctl enable mongod
sudo systemctl start mongod

echo "Provision app"
# Provision app
cp /vagrant/app/bootstrap.sh /home/vagrant
cp /vagrant/app/nodeserver.service /etc/systemd/system/
sudo chmod +x bootstrap.sh
sudo su -c ./bootstrap.sh - vagrant


#We mount each partition we have setup in fstab
# sudo mount -a
