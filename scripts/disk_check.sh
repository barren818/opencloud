#!/bin/bash
LOG=/var/log/cloudlab/disk_check.log
for mount in / /company-data /website-data
do
    usage=$(df $mount | awk 'NR==2 {print $5}' | tr -d '%')
    now=$(date '+%Y-%m-%d %H:%M:%S')
    if [ $usage -ge 80 ]
    then
        echo "$now WARNING: $mount 使用率 ${usage}%，超过80%阈值" >> $LOG
    else
        echo "$now OK: $mount 使用率 ${usage}%" >> $LOG
    fi
done
echo "巡检完成，结果已写入 $LOG"
