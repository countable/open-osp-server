#!/bin/bash

set -uxo

cd $HOME

if [ -z $HOME/dotfiles ]; then
	git clone https://github.com/countable-web/dotfiles.git
else
	echo "Skipping, dotfiles already exists"
fi

exists=$(grep -c "^jenkins:" /etc/passwd)

if [ $exists -eq 0 ]; then
	$HOME/dotfiles/deploy/setup-jenkins-slave
else
    echo "The user jenkins already exists"
fi

bash $HOME/dotfiles/deploy/unpack &
bash $HOME/dotfiles/deploy/setup-docker &

echo "Sleep 30 seconds, waiting for unpack and docker"
sleep 30

fallocate -l 10G /10gb

$HOME/dotfiles/bin/make-swapfile ${1:-60G}

apt install cron

echo "00 10 * * * jenkins cd /home/jenkins/open-osp-server && ./bin/updater.sh backup >> /home/jenkins/backups.log 2>&1" >> /etc/crontab
echo "00 * * * * jenkins cd /home/jenkins/open-osp-server && ./bin/updater.sh check >> /home/jenkins/checks.log 2>&1" >> /etc/crontab
echo "00 00 * * * admin cd /home/jenkins/open-osp-server && ./bin/updater.sh usage >> /home/jenkins/checks.log 2>&1" >> /etc/crontab


sudo -u jenkins -H sh -c "./haproxy.sh"

exit 0