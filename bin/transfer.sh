#!/bin/bash

sudo chown -R $1 jenkins

sudo -u jenkins $HOME/bin/transfer-as-jenkins.sh $1 $2

