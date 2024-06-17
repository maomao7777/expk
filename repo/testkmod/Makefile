SILENCE?=@
PROJECT_NAME            =   
MODULE_NAME             =   testkmod
VERSION                 =   $(shell dpkg-parsechangelog --show-field Version)

# Params define
PWD                     =   $(shell pwd)

MTEST = this is test print
##################
# Kernel Module
##################

ifneq ($(KERNELRELEASE),)

OBJS  := $(SRC:.c=.o)
$(MODULE_NAME)-objs := $(OBJS)

obj-m := $(MODULE_NAME).o

else

all: 
	@echo $(MTEST)
	$(MAKE) -C '$(LINUX_DIR)' M='$(PWD)' modules

clean:
	$(MAKE) -C '$(LINUX_DIR)' M='$(PWD)' clean
config:

endif

.PHONY: config clean

