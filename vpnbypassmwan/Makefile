# Copyright 2017-2018 Stan Grishin (stangri@melmac.ca)
# This is free software, licensed under the GNU General Public License v3.

include $(TOPDIR)/rules.mk

PKG_NAME:=vpnbypassmwan
PKG_VERSION:=1.3.33-1
PKG_RELEASE:=1
PKG_LICENSE:=GPL-3.0-or-later
PKG_MAINTAINER:=Stan Grishin <stangri@melmac.ca>

include $(INCLUDE_DIR)/package.mk

define Package/vpnbypassmwan
	SECTION:=net
	CATEGORY:=Network
	TITLE:=VPN Bypass Service with MultiWAN Support
	URL:=https://docs.openwrt.melmac.net/vpnbypass/
	DEPENDS:=+ipset +iptables
	PKGARCH:=all
endef

define Package/vpnbypassmwan/description
!MODIFIED for Multi-WAN!
This service can be used to enable simple VPN split tunnelling.
Supports accessing domains, IP ranges outside of your VPN tunnel.
Also supports dedicating local ports/IP ranges for direct
internet access (outside of your VPN tunnel).
Please see the README for further information.
endef

define Package/vpnbypassmwan/conffiles
/etc/config/vpnbypassmwan
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/vpnbypassmwan/install
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_DIR) $(1)/etc/hotplug.d/firewall
	$(INSTALL_BIN) ./files/vpnbypassmwan.init $(1)/etc/init.d/vpnbypassmwan
	$(SED) "s|^\(PKG_VERSION\).*|\1='$(PKG_VERSION)-$(PKG_RELEASE)'|" $(1)/etc/init.d/vpnbypassmwan
	$(INSTALL_CONF) ./files/vpnbypassmwan.config $(1)/etc/config/vpnbypassmwan
	$(INSTALL_DATA) ./files/vpnbypassmwan.hotplug $(1)/etc/hotplug.d/firewall/94-vpnbypassmwan
endef

define Package/vpnbypassmwan/postinst
	#!/bin/sh
	# check if we are on real system
	if [ -z "$${IPKG_INSTROOT}" ]; then
		/etc/init.d/vpnbypassmwan enable
	fi
	exit 0
endef

define Package/vpnbypassmwan/prerm
	#!/bin/sh
	# check if we are on real system
	if [ -z "$${IPKG_INSTROOT}" ]; then
		echo "Stopping service and removing rc.d symlink for vpnbypassmwan"
		/etc/init.d/vpnbypassmwan stop || true
		/etc/init.d/vpnbypassmwan disable || true
	fi
	exit 0
endef

$(eval $(call BuildPackage,vpnbypassmwan))
