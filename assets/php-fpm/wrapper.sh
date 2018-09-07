#!/bin/bash

# Start php-fpm
service php5.6-fpm start

# Check if they are both running
while /bin/true; do
  ps aux |grep php-fpm |grep -q -v grep
  PROCESS_1_STATUS=$?

  if [ $PROCESS_1_STATUS -ne 0 ]; then
    echo "One of the processes has already exited."
    exit -1
  fi
  sleep 60
done
