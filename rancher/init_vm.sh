#!/bin/sh
current_dir=$(dirname "$(greadlink -f "$0")")

source ${current_dir}/../infra.env
source ${current_dir}/../scripts/lib.sh

REGISTRY_HOST_IP=$(docker-machine ip ${REGISTRY_HOST_NAME})

if [ "$?" == "1" ] ;then
 echo -e "[WARNING]-No custom docker proxy mirror registry found!\nLoading docker rancher host without it.\n"
else
 echo -e "[INFO]-Custom docker proxy mirror registry found in [${REGISTRY_HOST_NAME}-$REGISTRY_HOST_IP]!\nLoading docker rancher host without it.\n"
 OPT_ENGINE_REGISTRY_MIRROR="--engine-registry-mirror https://${REGISTRY_HOST_NAME}:${REGISTRY_HOST_HOST_PORT}"
 OPT_ENGINE_INSECURE_REGISTRY="--engine-insecure-registry https://${REGISTRY_HOST_NAME}:${REGISTRY_HOST_HOST_PORT}"
fi

docker-machine rm -f ${RANCHER_HOST_NAME}

docker-machine create ${RANCHER_HOST_NAME} \
--driver virtualbox \
--virtualbox-cpu-count ${RANCHER_HOST_CPU_COUNT} \
--virtualbox-disk-size  ${RANCHER_HOST_DISK_SIZE} \
--virtualbox-memory ${RANCHER_HOST_MEMORY} \
${OPT_ENGINE_REGISTRY_MIRROR} \
${OPT_ENGINE_INSECURE_REGISTRY} \
--engine-opt debug=${NB_DOCKER_NODE_HOST_DEBUG} \
--virtualbox-boot2docker-url=${BOOT2DOCKER_URL}

propagate_vm_hosts
dockerhub_login ${RANCHER_HOST_NAME}

${current_dir}/start_rancher_container.sh
