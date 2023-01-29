include $(TOPDIR)/rules.mk

PKG_NAME:=tinyfecvpn-easyconf
PKG_VERSION:=627160d
PKG_RELEASE:=1.0

PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=627160d0645e6d72b5f649d23ba09c068c648b7a
PKG_SOURCE_URL:=https://github.com/SmoothWAN/tinyfecVPN

include $(INCLUDE_DIR)/package.mk

PKG_BUILD_PARALLEL:=1
	
define Package/tinyfecvpn-easyconf
	SECTION:=VPN
	CATEGORY:=Network
	TITLE:=A VPN Designed for Lossy Links, with built-in Forward Error Correction(FEC) Support. Improves your Network Quality on a High-latency Lossy Link.
	URL:=https://github.com/wangyu-/tinyfecVPN
endef

define Package/engarde/description
A VPN Designed for Lossy Links, with built-in Forward Error Correction(FEC) Support. Improves your Network Quality on a High-latency Lossy Link.
endef

define Build/Compile
	( \
		pushd $(PKG_BUILD_DIR) ; \
		make nolimit ; \
		popd ; \
	)
endef

define Package/tinyfecvpn-easyconf/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/tinyvpn $(1)/usr/bin/tinyfecvpn
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_DATA) ./net/etc/config/tinyvpnconf $(1)/etc/config/tinyvpnconf
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./net/etc/init.d/tinyvpnconf $(1)/etc/init.d/tinyvpnconf
endef

$(eval $(call BuildPackage,tinyfecvpn-easyconf))
