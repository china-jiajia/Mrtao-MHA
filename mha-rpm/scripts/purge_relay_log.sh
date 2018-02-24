#!/bin/bash
user=root
passwd=123456
port=3306
host=localhost
log_dir='/masterha/log'
work_dir='/masterha'
purge='/usr/bin/purge_relay_logs'

source /etc/profile

if [ ! -d $log_dir ]
then
   mkdir $log_dir -p
fi

$purge --user=$user --host=$host --password=$passwd --disable_relay_log_purge --port=$port --workdir=$work_dir >> $log_dir/purge_relay_logs.log 2>&1

