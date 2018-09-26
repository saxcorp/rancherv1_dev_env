#!/bin/sh

if [ ! -e "/usr/local/bin/jq" ]; then
    sudo wget -O /usr/local/bin/jq https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64
    sudo chmod +x /usr/local/bin/jq
fi

PID=`curl -s -X GET -H "Accept: application/json" http://rancher:8080/v1/projects | jq -r '.data[0].id'`
TID=`curl -s -X POST -H "Accept: application/json" -H "Content-Type: application/json" http://rancher:8080/v1/projects/$PID/registrationTokens | jq -r '.id'`
touch token.json
while [ `jq -r .command token.json | wc -c` -lt 10 ]; do
    curl -s -X GET -H "Accept: application/json" http://rancher:8080/v1/projects/$PID/registrationToken/$TID > token.json
    sleep 1
done
CMD=`jq -r .command token.json`
eval $CMD
touch apiout.json
while [ `jq -r .secretValue apiout.json | wc -c` -eq 0 ]; do
    curl -s -X POST -H "Accept: application/json" -H "Content-Type: application/json" -d '{"accountId":"1a1", "publicValue":"publicKey", "secretValue":"secretKey"}' http://192.168.99.100:8080/v1/projects/apikeys > apiout.json
    sleep 1
done
