#!/bin/sh

echo "Uninstalling..."
uci del dhcp.@host[-1]
uci del dhcp.lan.dhcp_option
uci commit dhcp
lxc-stop PiHole
lxc-destroy PiHole

uci del lxc-auto container
uci commit lxc-auto

echo "Uninstallation finished. Restarting network interfaces."
/etc/init.d/network restart
