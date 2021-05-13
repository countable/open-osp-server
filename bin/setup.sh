#!/bin/sh

set -uxo

echo "********************************************************************"
echo "********************* OpenOsp Server Bootstrap *********************"
echo "********************************************************************"

cd $HOME

if [ -z $HOME/dotfiles ]; then
	echo "Skipping, dotfiles already exists"
else
	git clone https://github.com/countable-web/dotfiles.git
fi

exists=$(grep -c "^jenkins:" /etc/passwd)
if [ $exists -eq 0 ]; then
	$HOME/dotfiles/deploy/setup-jenkins-slave >> ./openosp-setup.log
else
    echo "Skipping, the user jenkins already exists"
fi

bash $HOME/dotfiles/deploy/setup-docker >> ./openosp-setup.log 2>&1 &

echo "Sleep 30 seconds, waiting for unpack and docker"
sleep 30

if [ -f "/10gb" ]; then
    echo "Already have /10gb file"
else
    echo "Creating 10gb file in root dir"
    fallocate -l 10G /10gb
fi


if [ -f "/swapfile" ]; then
    echo "Already have swapfile"
else
    $HOME/dotfiles/bin/make-swapfile ${1:-60G} >> ./openosp-setup.log
fi


apt -y install cron
apt -y install awscli

crontab -r
sudo crontab -l > tmpfile

sudo echo "00 10 * * * jenkins cd $HOME/open-osp-server && ./bin/updater.sh backup >> /home/jenkins/backups.log 2>&1" >> tmpfile
sudo echo "00 * * * * jenkins cd $HOME/open-osp-server && ./bin/updater.sh check >> /home/jenkins/checks.log 2>&1" >> tmpfile
sudo echo "00 00 * * * admin cd $HOME/open-osp-server && ./bin/updater.sh usage >> /home/jenkins/usage.log 2>&1" >> tmpfile

crontab /etc/crontab

sudo -u jenkins -H sh -c "`dirname $0`/haproxy.sh"

exit 0