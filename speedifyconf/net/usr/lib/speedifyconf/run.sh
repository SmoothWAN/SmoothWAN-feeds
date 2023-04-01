#!/bin/sh  /etc/rc.common

. /lib/functions.sh

ACTION="${1:-start}"
PKGS=/tmp/spdpkgs

config_load speedifyconf

run_speedify (){
   if [ $(uci get speedifyconf.Setup.enabled) == 0 ]; then
        exit 0
   fi

   cd /usr/share/speedify || exit 1
   sh DisableRpFilter.sh
   mkdir -p logs

   if [ $(uci get speedifyconf.Setup.killsw) == 1 ]; then
      uci del network.wan
      uci del dhcp.wan6=dhcp
      uci set network.wan=interface
      uci set network.wan.force_link='0'
      uci set network.wan.proto='static'
      uci set network.wan.device='connectify0'
      uci set network.wan.ipaddr='10.202.0.2'
      uci set network.wan.netmask='255.255.255.0'
      uci set network.wan.gateway='10.202.0.1'
      uci del_list firewall.cfg03dc81.network='wan'
      uci del_list firewall.cfg03dc81.network='wan6'
      uci add_list firewall.cfg03dc81.network='wan'
      uci add_list firewall.cfg03dc81.network='wan6'
      uci set network.wan6=interface
      uci set network.wan6.proto='dhcpv6'
      uci set network.wan6.device='connectify0'
      uci set network.wan6.reqaddress='try'
      uci set network.wan6.reqprefix='auto'
      uci set dhcp.wan6=dhcp
      uci set dhcp.wan6.interface='wan6'
      uci set dhcp.wan6.ignore='1'
      uci set dhcp.wan6.ra='relay'
      uci set dhcp.wan6.dhcpv6='relay'
      uci set dhcp.wan6.ndp='relay'
      uci set dhcp.wan6.master='1'
      uci commit network
      uci commit firewall
      uci commit dhcp
      ip tuntap add mode tun connectify0
      ip link set connectify0 mtu 14800 up
      ip route add 10.202.0.0/24 dev connectify0
      ip route add default via 10.202.0.1
      ip route add 0.0.0.0/1 dev connectify0 scope link
      ip route add 128.0.0.0/1 dev connectify0 scope link
      ip -6 route add 8000::/1 dev connectify0 metric 1 mtu 14800 pref medium
      ip -6 route add ::/1 dev connectify0 metric 1 mtu 14800 pref medium
      nice -n -20 capsh --drop=cap_sys_nice,cap_net_admin -- -c './speedify -d logs &'
   else
      uci del network.wan
      uci del network.wan6
      uci del_list firewall.cfg03dc81.network='wan'
      uci del_list firewall.cfg03dc81.network='wan6'
      uci add_list firewall.cfg03dc81.network='wan'
      uci add_list firewall.cfg03dc81.network='wan6'
      uci set network.wan=interface
      uci set network.wan.proto='none'
      uci set network.wan.device='connectify0'
      uci add_list firewall.cfg03dc81.network='wan'
      uci set network.wan6=interface
      uci set network.wan6.proto='dhcpv6'
      uci set network.wan6.device='connectify0'
      uci set network.wan6.reqaddress='try'
      uci set network.wan6.reqprefix='auto'
      uci set dhcp.wan6=dhcp
      uci set dhcp.wan6.interface='wan6'
      uci set dhcp.wan6.ignore='1'
      uci set dhcp.wan6.ra='relay'
      uci set dhcp.wan6.dhcpv6='relay'
      uci set dhcp.wan6.ndp='relay'
      uci set dhcp.wan6.master='1'
      uci commit network
      uci commit firewall
      uci commit dhcp
      ip tuntap del mode tun connectify0
      nice -n -20 capsh --drop=cap_sys_nice -- -c './speedify -d logs &'
   fi

   sleep 2
   ./speedify_cli startupconnect on > /dev/null

   if [ $(uci get speedifyconf.Setup.renamer) == 1 ]; then
      cp /etc/factoryconfig/99-usbnamer /etc/hotplug.d/net/99-usbnamer
   else
      rm /etc/hotplug.d/net/99-usbnamer
   fi
   /etc/init.d/adguardhome restart &
}

parse_versions(){
   APT=$(config_get Setup apt)
   APT=$(echo $APT | sed -e 's/\/$//')
   echo Repository URL:$APT
   aptURL="$APT$SPDDIR"
   echo Repository Ubuntu packages URL:$aptURL
   echo Note: Duplicated version is the Speedify UI version.
   curl -o $PKGS $aptURL
   cat $PKGS | grep Version
}

parse_apt_url(){
   APT=$(config_get Setup apt)
   APT=$(echo $APT | sed -e 's/\/$//')
   echo Repository URL:$APT
   aptURL="$APT$SPDDIR"
   echo Repository Ubuntu packages URL:$aptURL
   curl -o $PKGS $aptURL

   DWVER=$(awk '/Version:/{gsub("Version: ", "");print;exit}' $PKGS)
   echo Latest Version:$DWVER

   SPDDW=$(awk '/Filename/{gsub("Filename: ", "");print;exit}' $PKGS)
   export DWURL=$APT/$SPDDW
   echo Speedify package URL:$DWURL

   UIDW=$(sed -n '/speedifyui/{nnnnnnnn;p;q}' $PKGS | awk '/Filename/{gsub("Filename: ", "");print;exit}')
   export UIDWURL=$APT/$UIDW
   echo Speedify UI package URL:$UIDWURL

   if [[ $(config_get Setup verovd) ]]; then
        echo "Version override is set!"
        DWVER=$(config_get Setup verovd)
        echo "Set to $DWVER"
        SPDDW=$(sed -n '/'"$DWVER"'/{nn;p;q}' $PKGS | awk '/Filename/{gsub("Filename: ", "");print;exit}')
        export DWURL=$APT/$SPDDW
        echo Speedify package URL:$DWURL
        UIDW=$(sed -n '/'"$DWVER"'/{nn;p;q}' $PKGS | awk '/Filename/{gsub("Filename: ", "");print;exit}' | sed 's/speedify/speedifyui/g')
        export UIDWURL=$APT/$UIDW
        echo Speedify UI package URL:$UIDWURL
   fi
}

installall(){
   if [ "$(ping -q -c1 google.com &>/dev/null && echo 0 || echo 1)" = "1" ]; then
        echo "Internet connectivity issue. Stopping installation/update"
        run_speedify &
        exit 0
   fi

   rm -rf /tmp/spddw
   echo "Downloading Speedify..."
   wget -P /tmp/spddw/speedify/ "$DWURL"
   echo "Downloading Speedify UI..."
   wget -P /tmp/spddw/speedifyui/ "$UIDWURL"
   echo "Extracting Speedify..."
   cd /tmp/spddw/speedify/
   ar x *.deb
   tar -xzf data.tar.gz -C /
   mkdir -p /usr/share/speedify/logs
   echo "Extracting Speedify UI..."
   cd /tmp/spddw/speedifyui/
   ar x *.deb
   tar -xzf data.tar.gz -C /
   ln -sf /usr/share/speedifyui/files/* /www/spdui/
   echo "Deleting installation files..."
   rm -rf /tmp/spddw
   echo "Updating OpenWrt configration and starting Speedify..."
   uci set speedifyconf.Setup.version=$DWVER
   uci commit
   chmod 755 /etc/init.d/speedifyconf
   /etc/init.d/speedifyconf enable
   echo "Speedify is now installed, UI is has been installed in Status->Overview"
}


if [ $(uname -m) = "aarch64" ]; then
  ARCH=arm64
  SPDDIR="/dists/speedify/main/binary-arm64/Packages"
  elif [ $(uname -m) = "x86_64" ]; then
    ARCH=amd64
    SPDDIR="/dists/speedify/main/binary-amd64/Packages"
  else
    ARCH=armhf
    SPDDIR="/dists/speedify/main/binary-armhf/Packages"
fi


if [ "$ACTION" = "update" ]; then
  parse_apt_url
  installall
  killall -KILL speedify
  run_speedify
else
  if [ "$ACTION" = "stopkill" ]; then
    echo "Killing Speedify"
    killall -KILL speedify
    exit 0
  fi
  if [ "$ACTION" = "list-versions" ]; then
    parse_versions
    exit 0
  fi
  echo "Starting Speedify"
  AUPD=$(config_get Setup autoupdate)
  if [ "$AUPD" = 1 ]; then
    echo "Update on boot enabled."
    echo "Checking for updates..."
    parse_apt_url
    CURRVER=$(config_get Setup version | awk -F '|' -v 'OFS=|' '{ gsub(/[^0-9]/,"",$NF); print}')
    DWVER=$(echo $DWVER | awk -F '|' -v 'OFS=|' '{ gsub(/[^0-9]/,"",$NF); print}')
    echo "Current version: $CURRVER"
    echo "Repo version: $DWVER"
    if [ "$DWVER" -gt "$CURRVER" ]; then
        installall
        killall -KILL speedify
        run_speedify
        echo "Update finished, running."
        exit 0
    else
        echo "Up to date, running."
        killall -KILL speedify
        run_speedify
        exit 0
    fi
  else
    killall -KILL speedify
    run_speedify
    echo "Running"
 fi
fi