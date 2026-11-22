#!/bin/bash
LOG=/var/log/cloudlab/nginx_check.log
now=$(date '+%Y-%m-%d %H:%M:%S')
if systemctl is-active --quiet nginx
then
    echo "$now OK: nginx运行正常" >> $LOG
else
    echo "$now ERROR: nginx未运行，尝试自动重启" >> $LOG
    systemctl start nginx
    sleep 2
    now=$(date '+%Y-%m-%d %H:%M:%S')
    if systemctl is-active --quiet nginx
    then
        echo "$now RECOVERED: nginx已自动恢复" >> $LOG
    else
        echo "$now FAILED: 自动重启失败，需人工处理" >> $LOG
    fi
fi
echo "检查完成，结果已写入 $LOG"
