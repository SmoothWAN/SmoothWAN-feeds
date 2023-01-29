include $(TOPDIR)/rules.mk

PKG_NAME:=engarde-easyconf
PKG_VERSION:=17053b8
PKG_RELEASE:=1.0

PKG_SOURCE_PROTO:=git
PKG_SOURCE_VERSION:=17053b8e3d39bc8bc6678befc1a586d8725b2847
PKG_SOURCE_URL:=https://github.com/SmoothWAN/engarde

DEPENDS=:+screen

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/golang/golang-values.mk

PKG_BUILD_DEPENDS:=golang/host node/host
PKG_BUILD_PARALLEL:=1
KERNEL_ARCH= `\
	if [ "$(ARCH)" == "aarch64" ]; then \
		echo arm64; \
	elif [ "$(ARCH)" == "aarch64_be" ]; then \
		echo arm64; \
	elif [ "$(ARCH)" == "arm" ]; then \
		echo arm; \
	elif [ "$(ARCH)" == "armeb" ]; then \
		echo arm; \
	elif [ "$(ARCH)" == "x86_64" ]; then \
		echo x86_64; \
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
	
MAKE_VARS = \
	GOARCH=$($KERNEL_ARCH)

define Package/engarde-easyconf
	SECTION:=VPN
	CATEGORY:=Network
	TITLE:=A go network utility to create a reliable IP tunnel over multiple connections
	URL:=https://github.com/porech/engarde
endef

define Package/engarde-easyconf/description
A go network utility to create a reliable IP tunnel over multiple connections
endef

#Requires packr2 and node/npm to be installed on host
define Build/Compile
	( \
		pushd $(PKG_BUILD_DIR) ; \
		cd webmanager ; \
		npm install ; \
		npm run build ; \
		cd .. ; \
		make packr ; \
		CGO_ENABLED=0 GOOS=linux GOARCH=$(KERNEL_ARCH) ./build-scripts/build.sh server ; \
		CGO_ENABLED=0 GOOS=linux GOARCH=$(KERNEL_ARCH) ./build-scripts/build.sh client ; \
		popd ; \
	)
endef

define Package/engarde-easyconf/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/dist/linux/$(KERNEL_ARCH)/engarde-client.linux.$(KERNEL_ARCH) $(1)/usr/bin/engarde-client
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/dist/linux/$(KERNEL_ARCH)/engarde-server.linux.$(KERNEL_ARCH) $(1)/usr/bin/engarde-server
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_DATA) ./net/etc/config/engardeconf $(1)/etc/config/engardeconf
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./net/etc/init.d/engardeconf $(1)/etc/init.d/engardeconf
endef

$(eval $(call BuildPackage,engarde-easyconf))
