#!/bin/sh
current_dir=$(dirname "$(greadlink -f "$0")")

source ${current_dir}/infra.env
source ${current_dir}/scripts/lib.sh

#${current_dir}/registry/init_vm.sh
#${current_dir}/node/init_vm.sh
${current_dir}/rancher/init_vm.sh

#propagate_vm_hosts
#get_hosts_file_content_to_set
#
#echo -e "\n############################################ Control #################################################################"
#
#DOCKER_LAST_NODE_NAME="${PREFIX_ENV}node-${NB_DOCKER_NODE_HOST}"
#
#REGISTRY_HOST_IP=$(docker-machine ip ${REGISTRY_HOST_NAME})
#REGISTRY_HOST_URL="https://${REGISTRY_HOST_IP}:${REGISTRY_HOST_HOST_PORT}"
#
#echo -e "DOCKER_LAST_NODE_NAME=${DOCKER_LAST_NODE_NAME}\nREGISTRY_HOST_URL=${REGISTRY_HOST_URL}"
#
#eval $("docker-machine" env --shell bash ${DOCKER_LAST_NODE_NAME})
#docker  pull busybox:latest
#
#echo -e "\nDeleting images in ${DOCKER_LAST_NODE_NAME}."
#docker rmi busybox
#
#echo -e "\nChecking images on proxy mirror ${REGISTRY_HOST_URL}."
#curl -k  ${REGISTRY_HOST_URL}/v2/_catalog
#
