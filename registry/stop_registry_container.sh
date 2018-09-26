#!/bin/sh
current_dir=$(dirname "$(greadlink -f "$0")")

source ${current_dir}/../infra.env

#check registry docker host
REGISTRY=$(docker-machine ip ${REGISTRY_HOST_NAME})

if [ "$?" == "0" ] ;then
 echo "[stop_registry_container][INFO] Try to stop docker registry services."
 docker-machine ssh ${REGISTRY_HOST_NAME} <<EOF
docker update --restart=no  registry-mirror
docker stop registry-mirror
docker rm registry-mirror

docker update --restart=no  portainer
docker stop portainer
docker rm portainer
EOF
else
 echo "[stop_registry_container][WARNING] They is no docker registry host available : $RANCHER_HOST_NAME"
fi