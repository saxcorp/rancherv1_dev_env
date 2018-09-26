#!/bin/sh
current_dir=$(dirname "$(greadlink -f "$0")")

source ${current_dir}/../infra.env
source ${current_dir}/../scripts/lib.sh

docker-machine rm -f ${REGISTRY_HOST_NAME}

docker-machine create ${REGISTRY_HOST_NAME} \
 --driver virtualbox \
 --virtualbox-cpu-count ${REGISTRY_HOST_CPU_COUNT} \
 --virtualbox-disk-size ${REGISTRY_HOST_DISK_SIZE} \
 --virtualbox-memory ${REGISTRY_HOST_MEMORY} \
 --virtualbox-boot2docker-url=${BOOT2DOCKER_URL}

propagate_vm_hosts
dockerhub_login ${REGISTRY_HOST_NAME}

#${current_dir}/init_certificates.sh
${current_dir}/start_registry_container.sh

REGISTRY_HOST_IP=$(docker-machine ip ${REGISTRY_HOST_NAME})
echo "REGISTRY_HOST_IP = "${REGISTRY_HOST_IP}



