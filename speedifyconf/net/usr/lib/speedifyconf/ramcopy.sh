#!/bin/sh

while :
	do
		rsync -a --delete /tmp/speedify/logs/ /usr/share/speedify/logs
	sleep 2
done
