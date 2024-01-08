#!/bin/bash

#wget -q0 - https://www.mongodb.org/static/pgp/server-6.0.asc | sudo apt-key add -
#echo "dev [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/6.0 multiberse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list
apt update
apt install mongodb -y
systemctl status mongodb > check_mongo.txt
if grep -q running check_mongo.txt; then
    echo "Mongo is running"
fi
systemctl start mongodb
systemctl enable mongodb
