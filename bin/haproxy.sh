#!/bin/bash

set -uxo

cd $HOME
git clone https://github.com/countable/countable-haproxy.git haproxy

cd $HOME/haproxy
cp ./../haproxy/haproxy.cfg.template $HOME/haproxy/haproxy.cfg


if ! command -v docker-compose &> /dev/null
then
    echo "docker-compose could not be found"
else
	docker-compose up -d 
fi