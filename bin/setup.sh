#!/bin/bash

set -ex

cd $HOME

git clone https://github.com/countable-web/dotfiles.git

cd $HOME/dotfiles/deploy

exists=$(grep -c "^jenkins:" /etc/passwd)

if [ $exists -eq 0 ]; then
	./setup-jenkins-slave.sh
else
    echo "The user jenkins already exists"
fi

./setup-docker.sh

fallocate -l 10G /10gb

cd $HOME/dotfiles/bin

./make-swapfile ${1:-60G}

apt install cron

echo "00 10 * * * jenkins cd /home/jenkins/open-osp-server && ./bin/updater.sh backup >> /home/jenkins/backups.log 2>&1" >> /etc/crontab
echo "00 * * * * jenkins cd /home/jenkins/open-osp-server && ./bin/updater.sh check >> /home/jenkins/checks.log 2>&1" >> /etc/crontab
echo "00 00 * * * admin cd /home/jenkins/open-osp-server && ./bin/updater.sh usage >> /home/jenkins/checks.log 2>&1" >> /etc/crontab


cd $HOME
git clone https://github.com/countable/countable-haproxy.git haproxy
cd $HOME/haproxy

cp ./../haproxy/haproxy.cfg.template $HOME/haproxy/haproxy.cfg