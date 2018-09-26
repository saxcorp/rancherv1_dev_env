#!/bin/sh
current_dir=$(dirname "$(greadlink -f "$0")")

source ${current_dir}/infra.env
source ${current_dir}/scripts/lib.sh

 for vm in $(docker-machine ls --format "{{.Name}}")
 do
  echo "[delete_all_vms][ ${vm} ]"
   docker-machine rm -f ${vm}
 done
 