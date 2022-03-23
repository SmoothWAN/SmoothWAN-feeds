#!/bin/sh

/usr/share/speedify/speedify_cli stats >> /tmp/spdstat.log &
while :
do

tail -n 1000 /tmp/spdstat.log > /tmp/spdstat.logrotate
cat /tmp/spdstat.logrotate > /tmp/spdstat.log
rm /tmp/spdstat.logrotate
/usr/share/speedify/speedify_cli show currentserver > /tmp/spdsrv.log &
/usr/share/speedify/speedify_cli show settings > /tmp/spdset.log &

sleep 10
done

