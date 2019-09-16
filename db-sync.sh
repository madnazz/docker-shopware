#!/bin/bash

source .env.stable

echo PROJECT_NAME 2>&1 >/dev/null
echo SHOPWARE_ENV 2>&1 >/dev/null

echo DB_HOST 2>&1 >/dev/null
echo DB_DATABASE 2>&1 >/dev/null
echo DB_USERNAME 2>&1 >/dev/null
echo DB_PASSWORD 2>&1 >/dev/null
echo DB_PORT 2>&1 >/dev/null

echo HOST 2>&1 >/dev/null
echo USER 2>&1 >/dev/null

echo SHOPWARE_ENV 2>&1 >/dev/null

# Get date in dd-mm-yyyy format
NOW="$(date +"%d-%m-%Y_%s")"

echo "Fetch Database from Stable Envoirement"

ssh $USER@$SSH_HOST "mysqldump -u${DB_USERNAME} -p${DB_PASSWORD} $DB_DATABASE " > ${PROJECT_NAME}_tmp.sql

echo "Import Database Localhost"

docker exec -i ${PROJECT_NAME}_app mysql -uroot -proot -hmysql shopware < ${PROJECT_NAME}_tmp.sql

echo "Cleanup Temporary Database"

rm -rf ${PROJECT_NAME}_tmp.sql

