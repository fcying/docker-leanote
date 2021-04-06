#!/bin/bash

KEEP_DAYS=${KEEP_DAYS:-"30"}
BACKUP_HOUR=${BACKUP_HOUR:-"2"}
now=$(date +%Y%m%d%H%M)

if [ ! -f /tmp/first_run ]; then
    mkdir -p /leanote/data/db
    rm -f /leanote/data/db.log
    mongod --dbpath /leanote/data/db --fork --logpath /leanote/data/db.log

    # start crond
    /etc/init.d/cron restart

    # auto backup
    if [ "$AUTO_BACKUP" == "1" ]; then
        sed -i "s/0 0/0 ${BACKUP_HOUR}/" /leanote/crontab -i
    else
        sed -i "/init backup/d" /leanote/crontab
    fi

    crontab /leanote/crontab

    # init or restore db
    if [ ! -f /leanote/data/db/init_db_done ]; then
        if [ -d /leanote/data/db_backup ]; then
            restore_path=/leanote/data/db_backup/leanote
        else
            restore_path=/leanote/leanote/mongodb_backup/leanote_install_data
        fi
        echo "mongorestore " $restore_path
        mongorestore -d leanote --authenticationDatabase admin \
            --dir $restore_path
        touch /leanote/data/db/init_db_done
        rm -rf /leanote/data/db_backup
    fi

    # config
    if [ -f /leanote/data/app.conf ]; then
        mv /leanote/leanote/conf/app.conf /leanote/leanote/conf/app.conf_origin
    else
        mv /leanote/leanote/conf/app.conf /leanote/data
    fi
    ln -svf /leanote/data/app.conf /leanote/leanote/conf

    mkdir -p /leanote/backup
    mkdir -p /leanote/data/upload
    mkdir -p /leanote/data/files
    mkdir -p /leanote/data/mongodb_backup

    rm -r /leanote/leanote/public/upload
    ln -svf /leanote/data/upload /leanote/leanote/public/
    ln -svf /leanote/data/files /leanote/leanote/
    mv /leanote/leanote/mongodb_backup /leanote/leanote/mongodb_backup_origin
    ln -svf /leanote/data/mongodb_backup /leanote/leanote/

    touch /tmp/first_run
fi

# run
if [ "$1" == "bash" ]; then
    /bin/bash
elif [ "$1" == "backup" ]; then
    rm -rf /leanote/data/db_backup
    mongodump -d leanote \
        --authenticationDatabase admin \
        -o /leanote/data/db_backup
    cd /leanote/data
    tar czf leanote_${now}.tgz files mongodb_backup upload \
        app.conf db_backup
    rm -rf db_backup
    mv leanote_${now}.tgz /leanote/backup

    # check expired data
    if [ $(ls /leanote/backup | grep -c ".*") -gt $KEEP_DAYS ]; then
        find /leanote/backup/* -name "*.tgz" -mtime +$KEEP_DAYS -exec rm {} \;
    fi

    chown -R abc:abc /leanote/backup
else
    bash /leanote/leanote/bin/run.sh 2>&1 | tee /leanote/data/run.log
fi

