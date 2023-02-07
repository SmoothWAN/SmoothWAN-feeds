#!/bin/sh
while :
do
  /usr/bin/dmesg -T | grep P2P:IN=br-lan | awk '{print $1,$2,$3,$4,$5;printf "Torrenting detected from ";print $9;printf "\n"}' | tail -n 50 > /tmp/p2p.log
sleep 5
done