#!/bin/bash

# Start php-fpm
service php7.0-fpm start

# Start cron
service cron start

# Start postfix
service postfix start

# Check if they are both running
while /bin/true; do
  ps aux |grep php-fpm |grep -q -v grep
  PROCESS_1_STATUS=$?

  ps aux |grep cron |grep -q -v grep
  PROCESS_2_STATUS=$?

  ps aux |grep postfix |grep -q -v grep
  PROCESS_3_STATUS=$?

  if [ $PROCESS_1_STATUS -ne 0 -o $PROCESS_2_STATUS -ne 0 -o $PROCESS_3_STATUS -ne 0 ]; then
    echo "One of the processes has already exited."
    exit -1
  fi
  sleep 60
done