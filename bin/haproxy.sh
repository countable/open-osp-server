#!/bin/bash

set -uxo

cd $HOME

echo "$(whoami)"

if [ -z "$HOME/haproxy" ]; then
    echo "haproxy already installed"
else
    git clone https://github.com/countable/countable-haproxy.git haproxy
fi

cd $HOME/haproxy
cp ./../haproxy/haproxy.cfg.template $HOME/haproxy/haproxy.cfg
$HOME/haproxy/reload.sh

if ! command -v docker-compose &> /dev/null
then
    echo "docker-compose could not be found"
else
	docker-compose up -d 
fi

exit