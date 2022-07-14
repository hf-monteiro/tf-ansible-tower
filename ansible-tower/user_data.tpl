#!/bin/bash

sudo yum install wget -y
sudo yum update -y

sudo wget https://s3-example.s3.amazonaws.com/ansible-automation-platform-setup-bundle-2.1.0-1.tar.gz
sleep 40

sudo tar xvf ansible-automation-platform-setup-bundle-2.1.0-1.tar.gz
cd ansible-automation-platform-setup-bundle-2.1.0-1

sudo sed -i -e "s/admin_password=''/admin_password='Password123'/g" inventory
sudo sed -i -e "s/pg_password=''/pg_password='Password123'/g" inventory
sudo sed -i -e "s/registry_username=''/registry_username='bah.ansible'/g" inventory
sudo sed -i -e "s/registry_password=''/registry_password='bah.ansible@2022'/g" inventory



sudo ./setup.sh
sleep 120