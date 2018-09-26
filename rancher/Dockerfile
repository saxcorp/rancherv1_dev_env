FROM mysql/mysql-server:5.5

MAINTAINER ahamadi.ibrahim@gmail.com

ENV MSQL_BCK_DIR /mysql_last_bck
ENV MSQL_BCK_FILE_ARCHIVE mysql_last_bck.gz
ENV MSQL_BCK_FILE mysql_last_bck
ENV MSQL_BACKUP_FREQ 200

RUN mkdir ${MSQL_BCK_DIR}

COPY ./scripts/rancher_backup_restore.sh /
COPY ./scripts/entrypoint.sh /

RUN chmod +x /rancher_backup_restore.sh
RUN chmod +x /entrypoint.sh

EXPOSE 3306

ENTRYPOINT ["/entrypoint.sh"]

CMD ["mysqld"]