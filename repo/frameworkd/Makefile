SILENCE?=@
PROJECT_NAME            =   frameworkd
APP_NAME                =   frameworkd
VERSION                 =   $(shell dpkg-parsechangelog --show-field Version)

# Params define
PWD                     =   $(shell pwd)
BUILD_PATH              =   $(PWD)/build
INCLUDE_DIR             =   $(PWD)
SRC_DIR                 :=  $(PWD)
SOURCES                 :=  $(wildcard $(SRC_DIR)/*.c)
OBJECTS                 :=  $(SOURCES:$(SRC_DIR)/%.c=$(BUILD_PATH)/%.o)
USR_LIB_SYSTEMD_PATH    ?= /usr/lib/systemd/system
CFLAGS                  +=  -std=c99                                    \
                            -I$(PWD)/include
COMMON_LIBS             =
TTTEST= test--maomao

.PHONY: all
all: $(BUILD_PATH) $(APP_NAME)

$(BUILD_PATH):
	@echo $(TTTEST)
	$(SILENCE)mkdir -p $(BUILD_PATH)

$(OBJECTS): $(BUILD_PATH)/%.o:$(SRC_DIR)/%.c
	$(SILENCE)$(CC) $(CFLAGS)  -c -o $@ $<

$(APP_NAME): $(OBJECTS)
	$(SILENCE)$(CC) $(CFLAGS) $(COMMON_LIBS) -o $(BUILD_PATH)/$@ $^

.PHONY: install
install:
	$(SILENCE)mkdir -p $(DESTDIR)/sbin
	$(SILENCE)install $(BUILD_PATH)/$(APP_NAME) $(DESTDIR)/sbin/
# 	$(SILENCE)mkdir -p $(DESTDIR)/$(USR_LIB_SYSTEMD_PATH)/


.PHONY: clean
clean:
	$(SILENCE)rm -rf $(BUILD_PATH)
