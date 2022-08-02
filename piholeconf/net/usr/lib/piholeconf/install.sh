#!/bin/sh  /etc/rc.common

. /lib/functions.sh

ACTION="${1:-start}"

config_load piholeconf

setuplxc(){

sed -i "2s@.*@IPV4_ADDRESS=$IP/24@" /usr/lib/piholeconf/setupVars.conf
sed -i "23s@.*@lxc.net.0.ipv4.address = $IP/24@" /usr/lib/piholeconf/config
sed -i "24s@.*@lxc.net.0.ipv4.gateway = $GW@" /usr/lib/piholeconf/config
lxc-create --name PiHole --template download -- --dist debian --release bullseye --arch $ARCH --no-validate
cp /usr/lib/piholeconf/config /srv/lxc/PiHole/config
rm /srv/lxc/PiHole/rootfs/etc/network/interfaces
lxc-start PiHole
lxc-attach -n PiHole -- bash -c "echo > /etc/systemd/network/eth0.network"
lxc-stop PiHole
#Install PiHole
lxc-start PiHole
lxc-attach -n PiHole -- bash -c "echo DNS=8.8.8.8 >> /etc/systemd/resolved.conf && systemctl restart systemd-resolved"
lxc-attach -n PiHole -- bash -c "mkdir -p /etc/pihole"
cat /usr/lib/piholeconf/setupVars.conf | lxc-attach -n PiHole -- tee /etc/pihole/setupVars.conf
sleep 10 #delay for dnsmasq host bug
lxc-attach -n PiHole -- bash -c "apt update && apt install -y curl && curl -L https://install.pi-hole.net | bash /dev/stdin --unattended"
lxc-attach -n PiHole -- bash -c "/usr/local/bin/pihole -a -p $PASS"



uci add lxc-auto container
uci set lxc-auto.@container[-1].name=PiHole
uci set lxc-auto.@container[-1].timeout=30
uci commit lxc-auto

uci del dhcp.lan.dhcp_option
eval uci add_list dhcp.lan.dhcp_option='6, $IP'
uci commit dhcp
/etc/init.d/dnsmasq restart

}

if [ $(uname -m) = "aarch64" ]; then
  ARCH=arm64
  elif [ $(uname -m) = "x86_64" ]; then
    ARCH=amd64
  else
    ARCH=armhf
fi

IP=$(config_get Setup ip)
GW=$(uci get network.lan.ipaddr)
PASS=$(config_get Setup pass)

setuplxc