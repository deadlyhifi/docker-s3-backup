#!/bin/sh

echo "Creating crontab"
echo -e "$CRON_SCHEDULE /backup.sh\n" > /etc/crontabs/root
echo "Starting crond"
crond -f
