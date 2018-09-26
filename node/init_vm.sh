#!/bin/sh
current_dir=$(dirname "$(greadlink -f "$0")")

echo "#####################################################################################################################"

source ${current_dir}/../infra.env
source ${current_dir}/../scripts/lib.sh

#--engine-registry-mirror "https://192.168.99.110:5000"
OPT_ENGINE_REGISTRY_MIRROR=""
# --engine-insecure-registry "https://192.168.99.110:5000"
OPT_ENGINE_INSECURE_REGISTRY=""

function create_docker_host(){
 docker_node_name=$1

 docker-machine rm -f ${docker_node_name}

 docker-machine create ${docker_node_name} \
 --driver virtualbox \
 --virtualbox-cpu-count ${NB_DOCKER_NODE_HOST_CPU_COUNT} \
 --virtualbox-disk-size  ${NB_DOCKER_NODE_HOST_DISK_SIZE} \
 --virtualbox-memory ${NB_DOCKER_NODE_HOST_MEMORY} \
 ${OPT_ENGINE_REGISTRY_MIRROR} \
 ${OPT_ENGINE_INSECURE_REGISTRY} \
 --engine-opt dns=8.8.8.8 \
 --engine-opt debug=${NB_DOCKER_NODE_HOST_DEBUG} \
 --virtualbox-boot2docker-url=${BOOT2DOCKER_URL}
}

REGISTRY_HOST_IP=$(docker-machine ip ${REGISTRY_HOST_NAME})

if [ "$?" == "1" ] ;then
 echo -e "[WARNING]-No custom docker proxy mirror registry found!\nLoading docker host without it.\n"
else
 echo -e "[INFO]-Custom docker proxy mirror registry found in [${REGISTRY_HOST_NAME}-$REGISTRY_HOST_IP]!\nLoading docker host without it.\n"
 OPT_ENGINE_REGISTRY_MIRROR="--engine-registry-mirror https://${REGISTRY_HOST_NAME}:${REGISTRY_HOST_HOST_PORT}"
 OPT_ENGINE_INSECURE_REGISTRY="--engine-insecure-registry https://${REGISTRY_HOST_NAME}:${REGISTRY_HOST_HOST_PORT}"
fi

for i in $(seq 1 ${NB_DOCKER_NODE_HOST}); do
 name=${PREFIX_ENV}node-${i}
 echo "[INFO]-Creation docker node [${name}].";
 create_docker_host ${name}
 propagate_vm_hosts
 dockerhub_login ${name}
done

echo "[INFO] End of creation."

docker-machine ls


