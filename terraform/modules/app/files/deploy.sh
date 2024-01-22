#!/bin/bash
set -e
APP_DIR=${1:-$HOME}
# Народ в чате рекомендует DEBIAN_FRONTEND=noninteractive и цикл с прослушиванием активного apt'а
while ps ax | grep -i [a]pt; do sleep 10; done;
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y git
git clone -b monolith https://github.com/express42/reddit.git $APP_DIR/reddit
cd $APP_DIR/reddit
bundle install
sudo mv /tmp/puma.service /etc/systemd/system/puma.service
sudo systemctl start puma
sudo systemctl enable puma
