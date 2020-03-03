#!/bin/bash

# Start apache
service apache2 start
STATUS=$?
if [ $STATUS -ne 0 ]; then
  echo "Failed to start apache2: $STATUS"
  exit $STATUS
fi

# Loop through koha instances, check that each has a running apache2 process
while sleep 60; do
  ps aux | grep apache2 | grep -q -v grep
  PROCESS_APACHE_STATUS=$?
  if [ $PROCESS_APACHE_STATUS -ne 0 ]; then
    echo "Apache root process has exited."
    exit 1
  fi

  koha-list $1 | while read INSTANCE; do
    ps -u ${INSTANCE}-koha | grep apache2 | grep -q -v grep
    PROCESS_APACHE_STATUS=$?
    if [ $PROCESS_APACHE_STATUS -ne 0 ]; then
      echo "Apache process for ${INSTANCE} has exited."
      exit 1
    fi
  done
done
