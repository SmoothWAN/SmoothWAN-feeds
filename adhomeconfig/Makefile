
include $(TOPDIR)/rules.mk

PKG_NAME:=adhomeconfig
PKG_VERSION:=1.0

PKG_MAINTAINER:=TALMASH

include $(INCLUDE_DIR)/package.mk

define Package/adhomeconfig
  TITLE:=AdguardHome configuration
  SECTION:=net
  CATEGORY:=Network
  PKGARCH:=all
endef

define Package/adhomeconfig/description
Configure ADGH from LuCI.
endef

define Package/adhomeconfig/conffiles
/etc/config/adhomeconfig
endef

define Build/Prepare
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/adhomeconfig/install
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./net/etc/init.d/adhomeconfig $(1)/etc/init.d/adhomeconfig
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_DATA) ./net/etc/config/adhomeconfig $(1)/etc/config/adhomeconfig
	$(INSTALL_DIR) $(1)/etc
	$(INSTALL_DATA) ./net/etc/adguardhome.yaml $(1)/etc/adguardhome.yaml

endef

$(eval $(call BuildPackage,adhomeconfig))
