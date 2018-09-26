#!/bin/sh
current_dir=$(dirname "$(greadlink -f "$0")")

source ${current_dir}/infra.env
source ${current_dir}/scripts/lib.sh

 for vm in $(docker-machine ls --filter "state=Running" --format "{{.Name}}")
 do
  echo "[stop_all_vms][ ${vm} ]"
  docker-machine stop "${vm}"
 done
 