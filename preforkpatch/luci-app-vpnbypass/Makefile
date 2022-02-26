# Copyright 2017-2019 Stan Grishin (stangri@melmac.ca)
# This is free software, licensed under the GNU General Public License v3.

include $(TOPDIR)/rules.mk

PKG_LICENSE:=GPL-3.0-or-later
PKG_MAINTAINER:=Stan Grishin <stangri@melmac.ca>
PKG_VERSION:=1.3.4-1

LUCI_TITLE:=VPN Bypass Web UI MultiWAN Patch
LUCI_DESCRIPTION:=Provides Web UI for VPNBypass service.
LUCI_DEPENDS:=+luci-mod-admin-full +vpnbypass
LUCI_PKGARCH:=all

include $(TOPDIR)/feeds/luci/luci.mk

# call BuildPackage - OpenWrt buildroot signature
