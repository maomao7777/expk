#
# This file can be used to define package recipes (ie. example/example.mk
# like for packages bundled in Buildroot itself) or other custom
# configuration options or make logic.
#

include $(sort $(wildcard expk/package/*/*/*.mk))
