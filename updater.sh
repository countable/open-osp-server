#!/bin/bash
cd /home/jenkins/workspace
folders=$(ls -d * | grep -v kumo | grep -v test | grep -v colling | grep -v updater)

echo updating $folders

for environment in $folders
do
   echo $environment
   cd /home/jenkins/workspace
   cd $environment
   echo ''
   echo '************************************'
   echo 'Upating' $environment
   #git status
   #pull
   docker-compose  up -d
#   ./bin/migrations/2022.01.18.sh
#   openosp update
#   docker-compose up -d
#   sleep 30
#   docker-compose restart oscar

#   sleep 60
#   openosp health
#   if [[ $? == 0 ]]; then
#       echo "SUCCESS!"
#   else
#       echo "FAILED :("
#       exit 1
#   fi
done

