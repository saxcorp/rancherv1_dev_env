#!/bin/sh
current_dir=$(dirname "$(greadlink -f "$0")")

source ${current_dir}/../infra.env

mkdir -p ${REGISTRY_HOST_MOUNT_HOME}/mirror

#check registry docker host
REGISTRY=$(docker-machine ip ${REGISTRY_HOST_NAME})
if [ "$?" == "0" ] ;then
 echo "[start_registry_container][INFO] Try to start registry services."
 cp -f ${current_dir}/domain.crt ${REGISTRY_HOST_MOUNT_HOME}/mirror/
 cp -f ${current_dir}/domain.key ${REGISTRY_HOST_MOUNT_HOME}/mirror/
 cp -f ${current_dir}/config.yml ${REGISTRY_HOST_MOUNT_HOME}/mirror/

docker-machine ssh ${REGISTRY_HOST_NAME} <<EOF
docker run -d --restart=always -p ${REGISTRY_HOST_HOST_PORT}:${REGISTRY_HOST_ORIGIN_PORT} --name registry-mirror \
-v /etc/hosts:/etc/hosts -v ${REGISTRY_HOST_MOUNT_HOME}/mirror:/var/lib/registry \
registry:2 /var/lib/registry/config.yml

docker run -d -p 9000:9000 \
--restart always \
--name  portainer \
-v /etc/hosts:/etc/hosts \
-v /var/run/docker.sock:/var/run/docker.sock \
-v /opt/portainer:/data \
portainer/portainer

EOF
else
 echo "[start_registry_container][WARNING] They is no docker registry host available. Create it with init_vm.sh!"
fi
