#!/bin/sh
current_dir=$(dirname "$(greadlink -f "$0")")

source ${current_dir}/../infra.env

echo -e "
---------------------------------------- RANCHER ENV -------------------------------------------------
  RANCHER_DB_USER=$RANCHER_DB_USER
  RANCHER_DB_PWD=$RANCHER_DB_PWD
  RANCHER_DB_NAME=$RANCHER_DB_NAME
  RANCHER_DB_EXPOSE_PORT=$RANCHER_DB_EXPOSE_PORT
  RANCHER_DB_BACKUP_FREQ=$RANCHER_DB_BACKUP_FREQ
  RANCHER_HOST_MOUNT_CATTLE_HOME=$RANCHER_HOST_MOUNT_CATTLE_HOME
  RANCHER_HOST_MOUNT_DB_BACKUP=$RANCHER_HOST_MOUNT_DB_BACKUP
-------------------------------------------------------------------------------------------------------
"

export RANCHER_DB_USER=$RANCHER_DB_USER
export RANCHER_DB_PWD=$RANCHER_DB_PWD
export RANCHER_DB_NAME=$RANCHER_DB_NAME
export RANCHER_DB_EXPOSE_PORT=$RANCHER_DB_EXPOSE_PORT
export RANCHER_DB_BACKUP_FREQ=$RANCHER_DB_BACKUP_FREQ
export RANCHER_HOST_MOUNT_CATTLE_HOME=$RANCHER_HOST_MOUNT_CATTLE_HOME
export RANCHER_HOST_MOUNT_DB_BACKUP=$RANCHER_HOST_MOUNT_DB_BACKUP

#check Rancher docker host
RANCHER=$(docker-machine ip ${RANCHER_HOST_NAME})

if [ "$?" == "0" ] ;then
 echo "[start_rancher_container][INFO] Try to start rancher services."
 eval $(docker-machine env --shell bash ${RANCHER_HOST_NAME})
 echo "docker-compose up -d -f ${current_dir}/docker-compose.yml"
 cd ${current_dir}; docker-compose up -d
else
 echo "[start_rancher_container][WARNING] They is no rancher host available. Create it with init_vm.sh!"
fi

unset RANCHER_DB_USER
unset RANCHER_DB_PWD
unset RANCHER_DB_NAME
unset RANCHER_DB_EXPOSE_PORT
unset RANCHER_DB_BACKUP_FREQ
unset RANCHER_HOST_MOUNT_CATTLE_HOME
unset RANCHER_HOST_MOUNT_DB_BACKUP
