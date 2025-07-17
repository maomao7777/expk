################################################################################
#
# testd
#
################################################################################

TESTD_SITE="$(TOPDIR)/expk/repo/testd"

TESTD_CFLAGS = "$(TARGET_CFLAGS) -I$(STAGING_DIR)/usr/include"

define TESTD_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) CC=$(TARGET_CC) CXX=$(TARGET_CXX) LDFLAGS=$(TARGET_LDFLAGS) CFLAGS=$(TESTD_CFLAGS)\
	DESTDIR=$(STAGING_DIR)
endef

define TESTD_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR=$(TARGET_DIR) install CC=$(TARGET_CC)
endef

$(eval $(generic-package))

