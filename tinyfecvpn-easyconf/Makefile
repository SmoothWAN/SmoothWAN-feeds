include $(TOPDIR)/rules.mk

PKG_NAME:=tinyfecvpn-easyconf
PKG_VERSION:=627160d
PKG_RELEASE:=1.0

PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=627160d0645e6d72b5f649d23ba09c068c648b7a
PKG_SOURCE_URL:=https://github.com/SmoothWAN/tinyfecVPN

include $(INCLUDE_DIR)/package.mk

PKG_BUILD_PARALLEL:=1
KERNEL_ARCH= `\
	if [ "$(ARCH)" == "aarch64" ]; then \
		echo arm64; \
	elif [ "$(ARCH)" == "aarch64_be" ]; then \
		echo arm64; \
	elif [ "$(ARCH)" == "arm" ]; then \
		echo armv7; \
	elif [ "$(ARCH)" == "armeb" ]; then \
		echo arm; \
	elif [ "$(ARCH)" == "x86_64" ]; then \
		echo amd64; \
	elif [ "$(ARCH)" == "i686" ]; then \
		echo x86; \
	elif [ "$(ARCH)" == "mips64" ]; then \
		echo mips; \
	elif [ "$(ARCH)" == "mips64el" ]; then \
		echo mips; \
	elif [ "$(ARCH)" == "mips" ]; then \
		echo mips; \
	elif [ "$(ARCH)" == "mipsel" ]; then \
		echo mips; \
	elif [ "$(ARCH)" == "powerpc64le" ]; then \
		echo powerpc; \
	elif [ "$(ARCH)" == "powerpc" ]; then \
		echo powerpc; \
	elif [ "$(ARCH)" == "m68k" ]; then \
		echo m68k; \
	fi`
	
define Package/tinyfecvpn-easyconf
	SECTION:=VPN
	CATEGORY:=Network
	TITLE:=A VPN Designed for Lossy Links, with built-in Forward Error Correction(FEC) Support. Improves your Network Quality on a High-latency Lossy Link.
	URL:=https://github.com/wangyu-/tinyfecVPN
endef

define Package/engarde/description
A VPN Designed for Lossy Links, with built-in Forward Error Correction(FEC) Support. Improves your Network Quality on a High-latency Lossy Link.
endef

#TODO: Update original Makefile for new OpenWRT toolchain (Cross), use GH Actions builds for now
# define Build/Compile
# 	( \
# 		pushd $(PKG_BUILD_DIR) ; \
# 		make nolimit ; \
# 		popd ; \
# 	)
# endef

define Build/Compile
	( \
		pushd $(PKG_BUILD_DIR) ; \
		wget https://github.com/SmoothWAN/tinyfecVPN/releases/download/master/tinyvpn_$KERNEL_ARCH ; \
		popd ; \
	)
endef

define Package/tinyfecvpn-easyconf/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/tinyvpn_$KERNEL_ARCH $(1)/usr/bin/tinyfecvpn
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_DATA) ./net/etc/config/tinyvpnconf $(1)/etc/config/tinyvpnconf
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./net/etc/init.d/tinyvpnconf $(1)/etc/init.d/tinyvpnconf
	$(INSTALL_DIR) $(1)/etc/hotplug.d/iface
	$(INSTALL_BIN) ./etc/hotplug.d/iface/30-tinyfec $(1)/etc/hotplug.d/iface/30-tinyfec
endef

$(eval $(call BuildPackage,tinyfecvpn-easyconf))
