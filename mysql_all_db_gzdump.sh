#!/bin/bash 

MYSQL_ROOT_PASS=<!!!>
BACKUP_STORE_PATH=<!!!>

/usr/bin/mysql -uroot -p$MYSQL_ROOT_PASS -e "show databases\G"| /bin/grep -v "*" | /bin/awk '{ print $2; }' | /bin/grep -v "test" | /bin/grep -v "information_schema" | while read db_name; do
        echo "Backing up $db_name database"
        /usr/bin/mysqldump -uroot -p$MYSQL_ROOT_PASS --max_allowed_packet=16M --triggers --routines $db_name | gzip > $BACKUP_STORE_PATH/$db_name-db-dump-`/bin/date +"%Y-%m-%d"`.sql.gz
done
