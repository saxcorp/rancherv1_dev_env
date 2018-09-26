#!/bin/bash

db_is_available_last_log_exec=""

function db_is_available(){
 res="0"
 db_is_available_last_log_exec=" mysqladmin --user="${MYSQL_USER}" --password="${MYSQL_PASSWORD}"  status "
 db_is_available_last_log_exec=${db_is_available_last_log_exec}" => "$( mysqladmin --user="${MYSQL_USER}" --password="${MYSQL_PASSWORD}"  status 2>&1 ) || res="1"
 echo $res
}

function manage_restoration(){
 echo "[Rancher_backup_restore][INFO] - manage_restoration"
 if [ -f "${MSQL_BCK_DIR}/${MSQL_BCK_FILE_ARCHIVE}" ]
 then
	echo "[Rancher_backup_restore][INFO] - MySql backup found: ${MSQL_BCK_DIR}/${MSQL_BCK_FILE_ARCHIVE}"
	echo "[Rancher_backup_restore][INFO] - all databases."
	back_date=$(date +"%Y%m%d_%H%M%S")
    echo -e "[${back_date}] manage_restoration " >> ${MSQL_BCK_DIR}/${MSQL_BCK_FILE}_history.txt

	mysql --user=$MYSQL_USER --password=$MYSQL_PASSWORD  -e "SHOW DATABASES;" | \
	grep -v Database | grep -v mysql | grep -v information_schema | grep -v test | \
	gawk '{print "DROP DATABASE " $1 ";"}' | \
	mysql --user=$MYSQL_USER --password=$MYSQL_PASSWORD

	echo "[Rancher_backup_restore][INFO] - Restaure last baskup."
	cd ${MSQL_BCK_DIR}; gunzip ${MSQL_BCK_FILE_ARCHIVE}
	mysql  --user=$MYSQL_USER --password=$MYSQL_PASSWORD < ${MSQL_BCK_DIR}/${MSQL_BCK_FILE}
    gzip ${MSQL_BCK_DIR}/${MSQL_BCK_FILE}
 fi
}

function backup_routine(){
 echo "[Rancher_backup_restore][INFO] - backup_routine"
 while /bin/true; do
    sleep ${MSQL_BACKUP_FREQ}

    if [ "$(db_is_available)" == "0" ]; then
     mysqldump --user=$MYSQL_USER --password=$MYSQL_PASSWORD  -A | gzip > ${MSQL_BCK_DIR}/${MSQL_BCK_FILE_ARCHIVE}_tmp
     rm ${MSQL_BCK_DIR}/${MSQL_BCK_FILE_ARCHIVE} &>/dev/null
     mv ${MSQL_BCK_DIR}/${MSQL_BCK_FILE_ARCHIVE}_tmp ${MSQL_BCK_DIR}/${MSQL_BCK_FILE_ARCHIVE}

     back_date=$(date +"%Y%m%d_%H%M%S")
     echo -e "[${back_date}] backup_routine" >> ${MSQL_BCK_DIR}/${MSQL_BCK_FILE}_history.txt
     echo "[Rancher_backup_restore][backup_routine][INFO] - ${back_date}"
    else
     echo "[Rancher_backup_restore][backup_routine][ERROR] - Db is not available. Skip bck routine! : ${db_is_available_last_log_exec}"
    fi
 done
}

for i in {30..0}; do
 sleep 2
 echo "[Rancher_backup_restore][INFO] - db_is_available ${i}... "
 if [ "$(db_is_available)" == "0" ]; then
  manage_restoration
  break
 else
   echo "[Rancher_backup_restore][ERROR] - db_is_available ${i} log : ${db_is_available_last_log_exec}"
 fi
done

if [ "$(db_is_available)" == "0" ]; then
 echo "[Rancher_backup_restore][INFO] - db_is_available!"
 backup_routine
else
 echo "[Rancher_backup_restore][ERROR] - db_is_available log : ${db_is_available_last_log_exec}"
fi

echo "[Rancher_backup_restore][INFO] - End rancher_backup_restore.sh  $@"
