
include $(TOPDIR)/rules.mk

PKG_NAME:=piholeconf
PKG_VERSION:=1.3

PKG_MAINTAINER:=TALMASH

include $(INCLUDE_DIR)/package.mk

define Package/piholeconf
  TITLE:=Pi-hole setup and configuration using LXC
  SECTION:=net
  CATEGORY:=Network
  PKGARCH:=all
endef

define Package/piholeconf/description
Install and configure Pi-hole from LuCI with LXC.
endef

define Package/piholeconf/conffiles
/etc/config/piholeconf
endef

define Build/Prepare
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/piholeconf/install
	$(INSTALL_DIR) $(1)/usr/lib/piholeconf
	$(INSTALL_DATA) ./net/usr/lib/piholeconf/install.sh $(1)/usr/lib/piholeconf/install.sh
	$(INSTALL_DATA) ./net/usr/lib/piholeconf/uninstall.sh $(1)/usr/lib/piholeconf/uninstall.sh
	$(INSTALL_DATA) ./net/usr/lib/piholeconf/setupVars.conf $(1)/usr/lib/piholeconf/setupVars.conf
	$(INSTALL_DATA) ./net/usr/lib/piholeconf/config $(1)/usr/lib/piholeconf/config
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_DATA) ./net/etc/config/piholeconf $(1)/etc/config/piholeconf

endef

$(eval $(call BuildPackage,piholeconf))
