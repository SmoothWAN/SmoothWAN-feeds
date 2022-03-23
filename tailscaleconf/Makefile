
include $(TOPDIR)/rules.mk

PKG_NAME:=tailscaleconf
PKG_VERSION:=3.3
PKG_RELEASE:=3.3

PKG_MAINTAINER:=TALMASH

include $(INCLUDE_DIR)/package.mk

define Package/tailscaleconf
  SUBMENU:=VPN
  TITLE:=Tailscale setup and configuration
  SECTION:=net
  CATEGORY:=Network
  PKGARCH:=all
endef

define Package/tailscaleconf/description
Install and configure Tailscale from LuCI/WebUI.
endef

define Package/tailscaleconf/conffiles
/etc/config/tailconf
endef

define Build/Prepare
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/tailscaleconf/install
	$(INSTALL_DIR) $(1)/usr/lib/tailconf
	$(INSTALL_BIN) ./net/usr/lib/tailconf/run.sh $(1)/usr/lib/tailconf/run.sh
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_DATA) ./net/etc/config/tailconf $(1)/etc/config/tailconf
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_DATA) ./net/etc/init.d/tailconf $(1)/etc/init.d/tailconf
endef

$(eval $(call BuildPackage,tailscaleconf))
