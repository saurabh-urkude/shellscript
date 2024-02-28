#!/bin/bash

# Script can be used to take daily backup by setting up Cron Jobs
# Also this script can delete backups which are older than 35 days

user=$(whoami)
date=$(date | awk '{print $3"/"$2"/"$6}')

echo -e "------------------------------------------------------------------------------------------------------------"
echo -e "                                  Backup Script started by $user on $date                                   " 
echo -e "------------------------------------------------------------------------------------------------------------" 

current_timestamp=$(date "+%Y-%m-%d")

src_dir=/home/ec2-user/scripts
tgt_dir=/home/ec2-user/backups

backup_file=$tgt_dir/backup-$current_timestamp.tgz

echo "Taking backup..................."

tar cvzf $backup_file --absolute-names $src_dir

if [ $? -eq 0 ]; then
    echo "Backup Complete."
else
    echo "Backup failed"
fi

echo "Checking 35 days old backup"

count=$(find $tgt_dir -type f -mtime +35 | wc -l)

if [ "$count" -eq 0 ]; then
    echo "35 days older backups are not present"
else
    echo "Removing 35 days old backups"
    find $tgt_dir -type f -mtime +35 -print0 | xargs -0 rm
    if [ $? -eq 0 ]; then
        echo "Removed 35 days old backups"
    else
        echo "Failed to remove 35 days old backups"
    fi
fi

echo -e "------------------------------------------------------------------------------------------------------------"
