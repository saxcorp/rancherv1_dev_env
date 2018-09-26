#!/bin/sh

current_dir=$(dirname "$(greadlink -f "$0")")

source ${current_dir}/infra.env
source ${current_dir}/scripts/lib.sh

start_vm_stopped_hosts
propagate_vm_hosts
get_hosts_file_content_to_set
