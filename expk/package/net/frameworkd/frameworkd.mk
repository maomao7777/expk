################################################################################
#
# frameworkd
#
################################################################################

FRAMEWORKD_SITE="$(TOPDIR)/expk/repo/frameworkd"
# FRAMEWORK_DEMON_DEPENDENCIES=systemd
FRAMEWORKD_CFLAGS = "$(TARGET_CFLAGS) -I$(STAGING_DIR)/usr/include"

define FRAMEWORKD_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) CC=$(TARGET_CC) CXX=$(TARGET_CXX) LDFLAGS=$(TARGET_LDFLAGS) CFLAGS=$(FRAMEWORKD_CFLAGS)\
	DESTDIR=$(STAGING_DIR)
endef

define FRAMEWORKD_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) install CC=$(TARGET_CC)
endef

$(eval $(generic-package))

