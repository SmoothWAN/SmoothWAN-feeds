#!/bin/sh  /etc/rc.common

. /lib/functions.sh

ACTION="${1:-start}"

config_load tailconf

run_tailscale (){
  SUB=$(uci get network.lan.ipaddr | awk -F. '{print $1 "." $2 "." $3 "." "0"}')
  cd /usr/share/tailscale || exit 1
  ./tailscaled -tun br-tailscale0 --state /usr/share/tailscale/tailscaled.state 2> /tmp/tailscaled.log &
  ./tailscale up --advertise-exit-node --accept-dns=false --advertise-routes="$SUB/24" --reset
  ./tailscale web --listen=0.0.0.0:8088 &
}

parse_pkg_url(){
  PKGS="/tmp/tailpkgs"
  rm $PKGS/stable
  wget -P $PKGS https://pkgs.tailscale.com/stable
  VER=$(awk '/tailscale_/{gsub("", "");print;exit}' $PKGS/stable |  awk -v FS="(tailscale_|_386)" '{print $2}')
  
  if [ $(uname -m) = "aarch64" ]; then 
    PKG_URL="https://pkgs.tailscale.com/stable/tailscale_"$VER"_arm64.tgz"
    ARCH="arm64"
  elif [ $(uname -m) = "x86_64" ]; then
    PKG_URL="https://pkgs.tailscale.com/stable/tailscale_"$VER"_amd64.tgz"
    ARCH="amd64"
  else
    PKG_URL="https://pkgs.tailscale.com/stable/tailscale_"$VER"_arm.tgz"
    ARCH="arm"
  fi
}

install_tailscale(){
  if [ "$(ping -q -c1 google.com &>/dev/null && echo 0 || echo 1)" = "1" ]; then
      echo "Internet connectivity issue. Stopping installation/update"
      run_tailscale
      exit 0
  fi

  echo "Downloading Tailscale"
  wget -P /tmp/taildw/ "$PKG_URL"
  tar -xvf /tmp/taildw/tailscale_"$VER"_"$ARCH".tgz -C /tmp/taildw/
  mkdir -p /usr/share/tailscale
  cp /tmp/taildw/tailscale_"$VER"_"$ARCH"/* /usr/share/tailscale
  echo "Deleting download cache"
  rm -rf /tmp/taildw
  echo "Updating configuration"
  uci set tailconf.Setup.version=$VER
  uci commit
  chmod 755 /etc/init.d/tailconf
  /etc/init.d/tailconf enable
  echo "Tailscale is now installed and running"
}

uninstall_tailscale(){
  kill_tailscale
  rm -rf /usr/share/tailscale
  /etc/init.d/tailconf disable
  uci set tailconf.Setup.autupdate=0
  uci commit tailconf
  echo "Tailscale uninstalled"
}

kill_tailscale(){
  killall -KILL tailscaled
  killall -KILL tailscale
}
   
if [ "$ACTION" = "update" ]; then
  parse_pkg_url
  install_tailscale
  kill_tailscale
  run_tailscale
else
  if [ "$ACTION" = "uninstall" ]; then
    uninstall_tailscale
    exit 0
  fi
  echo "Starting Tailscale"
  AUPD=$(config_get Setup autoupdate)
  if [ "$AUPD" = 1 ]; then
    echo "Update on boot enabled"
    parse_pkg_url
    CURRVER=$(config_get Setup version | awk -F '|' -v 'OFS=|' '{ gsub(/[^0-9]/,"",$NF); print}')
    DWVER=$(echo $VER | awk -F '|' -v 'OFS=|' '{ gsub(/[^0-9]/,"",$NF); print}')
    echo "Current version: $CURRVER"
    echo "Repo version: $DWVER"
    if [ "$DWVER" -gt "$CURRVER" ]; then
      kill_tailscale
      install_tailscale
      run_tailscale
      echo "Update finished, running"
      exit 0
    else
      echo "Up to date, running"
      kill_tailscale
      run_tailscale
      exit 0
    fi
  else
    kill_tailscale
    run_tailscale
    echo "Running"
 fi
fi
