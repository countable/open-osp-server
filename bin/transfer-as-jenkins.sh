#!/bin/bash

echo "Jenkins must have the ssh public key copied to dest server."

source $1/local.env

cd $1

docker-compose stop oscar expedius faxws

echo "Zip the DB"

docker-compose exec db mysql -uroot -p${MYSQL_ROOT_PASSWORD} | gzip > $1.sql.gz

docker-compose down

cd ..

# send everything over.
tar -I lz4 -cf - $1 | pv | ssh $2.openosp.ca "tar -I lz4 -xf -"

ssh $2.openosp.ca << EOF
  cd workspace/$1
  docker-compose up -d db
  docker-compose exec db apt-get update
  docker-compose exec db apt-get install pv
  docker-compose exec db pv reach.sql.gz | gunzip | mysql -u root -p${MYSQL_ROOT_PASSWORD} oscar
EOF

# alternative way to transfer files, with rsync
#rsync -av --exclude volumes ./ destination.openosp.ca:/home/jenkins/workspace/clinicname/

