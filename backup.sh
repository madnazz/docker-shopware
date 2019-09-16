#!/bin/bash
# Daily Backup Script

source .env.stable

echo PROJECT_NAME 2>&1 >/dev/null
echo SHOPWARE_ENV 2>&1 >/dev/null

echo DB_HOST 2>&1 >/dev/null
echo DB_DATABASE 2>&1 >/dev/null
echo DB_USERNAME 2>&1 >/dev/null
echo DB_PASSWORD 2>&1 >/dev/null
echo DB_PORT 2>&1 >/dev/null

projectfolder=websto23.myhostpoint.ch
date=`date +%F_%H-%M`

mkdir -p $HOME/backups
cd $HOME/www

echo Start File Backup...

# tar -czf $HOME/backups/${projectfolder}_$date.tar.gz --exclude "$HOME/www/${projectfolder}/var/cache" --exclude "$HOME/www/${projectfolder}/var/log" --exclude "$HOME/www/${projectfolder}/web/cache" $projectfolder

echo Finish File Backup...

echo Start Database Backup...

mysqldump -u$DB_USERNAME -p$DB_PASSWORD $DB_DATABASE | gzip -9 > $HOME/backups/${projectfolder}_$date.sql.gz

echo Finish Database Backup...

echo Clean up old Backups

#Delete last X days old backup
find /$HOME/backups -mtime +14 -exec rm {} \;

exit 0
