#!/bin/sh

PREFIX_DNS="dockerlocal"

function get_hosts_file_content(){
 for vm in $(docker-machine ls --filter "state=Running" --format "{{.Name}}")
 do
  echo "$(docker-machine ip ${vm}) ${vm} ${vm}.${PREFIX_DNS}"
 done
}

function update_vm_hosts(){
 vm_name=$1
 hosts_file_content=$(get_hosts_file_content)
 echo "[update_vm_hosts][ ${vm_name} ]"
 docker-machine ssh ${vm_name} <<EOF
 sudo sed -i '/${PREFIX_DNS}/d' /etc/hosts
 echo "${hosts_file_content}" | sudo tee -a /etc/hosts

EOF
}

function propagate_vm_hosts(){
 for vm in $(docker-machine ls --filter "state=Running" --format "{{.Name}}")
 do
  update_vm_hosts ${vm}
 done
}

function start_vm_stopped_hosts(){
 for vm in $(docker-machine ls --filter "state=Stopped" --format "{{.Name}}")
 do
  echo "[start_vm_stopped_hosts][ ${vm} ]"
  docker-machine start ${vm}
 done
}

function get_hosts_file_content_to_set(){
 echo -e "\nAdd dns for vm on your Hosts file.
 Windows -> C:/Windows/System32/drivers/etc/hosts
 Unix    -> /etc/hosts
 --------------------------------------hosts----------------------------------"
 echo "$(get_hosts_file_content)"
 echo "-----------------------------------------------------------------------------"
}

function dockerhub_login(){
 vm_name=$1
 login=${REGISTRY_ACCOUNT_LOGIN}
 password=${REGISTRY_ACCOUNT_PWD}
 HOST=$(docker-machine ip ${vm_name})

 if [ "$?" == "0" ] ;then
  echo "[dockerhub_login][INFO] Login vm ${vm_name} to docker hub with account [${login}]."
  docker-machine ssh ${vm_name} <<EOF
echo "${password}" | sudo docker login --username "${login}" --password-stdin
EOF
else
 echo "[dockerhub_login][WARNING] No vm [${vm_name}] found!"
fi
}