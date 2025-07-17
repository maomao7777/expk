################################################################################
#
# testkmod
#
################################################################################

TESTKMOD_MODULE_VERSION = 1.0
TESTKMOD_SITE_METHOD = local
TESTKMOD_LICENSE = GPLv2
TESTKMOD_SITE="$(TOPDIR)/expk/repo/testkmod"
# FRAMEWORK_DEMON_DEPENDENCIES=systemd
# TESTKMOD_CFLAGS = "$(TARGET_CFLAGS)" ARCH='arm64' CROSS_COMPILE=aarch64-linux-gnu-

# define TESTKMOD_BUILD_CMDS
# 	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) LINUX_DIR='$(LINUX_DIR)' CC=$(TARGET_CC) LD='$(TARGET_LD)' CFLAGS=$(TESTKMOD_CFLAGS)\
# 	DESTDIR=$(STAGING_DIR)
# endef

define KERNEL_MODULE_BUILD_CMDS
        $(MAKE) -C '$(@D)' LINUX_DIR='$(LINUX_DIR)' CC='$(TARGET_CC)' LD='$(TARGET_LD)' modules
endef

define TESTKMOD_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) install CC=$(TARGET_CC)
endef
$(eval $(kernel-module))
$(eval $(generic-package))

