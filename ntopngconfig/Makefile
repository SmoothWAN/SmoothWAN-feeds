include $(TOPDIR)/rules.mk

PKG_NAME:=ntopngconfig
PKG_VERSION:=1.0

PKG_MAINTAINER:=TALMASH

include $(INCLUDE_DIR)/package.mk

define Package/ntopngconf
  SUBMENU:=VPN
  TITLE:=Custom SmoothWAN ntopng (chroot) configuration
  SECTION:=net
  CATEGORY:=Network
  PKGARCH:=all
endef

define Package/ntopngconf/description
Install or configure ntopng from LuCI/WebUI.
endef

define Package/ntopngconf/conffiles
/etc/config/ntopconf
endef

define Build/Prepare
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/ntopngconf/install
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_DATA) ./net/etc/config/ntopconf $(1)/etc/config/ntopconf
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./net/etc/init.d/ntopngconf $(1)/etc/init.d/ntopngconf
endef

$(eval $(call BuildPackage,ntopngconf))
