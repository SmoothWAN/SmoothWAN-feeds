#!/bin/sh  /etc/rc.common

. /lib/functions.sh

ACTION="${1:-start}"

config_load piholeconf

setuplxc(){


lxc-create --name PiHole --template download -- --dist debian --release bullseye --arch $ARCH --no-validate
cp /usr/lib/piholeconf/config /srv/lxc/PiHole/config
rm /srv/lxc/PiHole/rootfs/etc/network/interfaces
lxc-start PiHole
lxc-attach -n PiHole -- bash -c "echo 'nameserver 8.8.8.8' >> /etc/resolv.conf"
lxc-attach -n PiHole -- bash -c "mkdir -p /etc/pihole"
cat /usr/lib/piholeconf/setupVars.conf | lxc-attach -n PiHole -- tee /etc/pihole/setupVars.conf
sleep 10 #delay for dnsmasq lxc internal delay
lxc-attach -n PiHole -- bash -c "apt update && apt install -y curl && curl -L https://install.pi-hole.net | bash /dev/stdin --unattended" &&
lxc-attach -n PiHole -- bash -c "/usr/local/bin/pihole -a -p $PASS"



uci add lxc-auto container
uci set lxc-auto.@container[-1].name=PiHole
uci set lxc-auto.@container[-1].timeout=30
uci commit lxc-auto

uci del dhcp.lan.dhcp_option
uci add_list dhcp.lan.dhcp_option='6,172.17.17.3'
uci commit dhcp

}



if [ $(uname -m) = "aarch64" ]; then 
  ARCH=arm64
  else
  ARCH=amd64
fi

PASS=$(config_get Setup pass)

setuplxc
