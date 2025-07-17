SILENCE?=@
PROJECT_NAME            =   myctrl
APP_NAME                =   myctrl
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
MTEST = this is maomao ctrl print

.PHONY: all
all: $(BUILD_PATH) $(APP_NAME)

$(BUILD_PATH):
	@echo $(MTEST)
	$(SILENCE)mkdir -p $(BUILD_PATH)

$(OBJECTS): $(BUILD_PATH)/%.o:$(SRC_DIR)/%.c
	$(SILENCE)$(CC) $(CFLAGS)  -c -o $@ $<

$(APP_NAME): $(OBJECTS)
	$(SILENCE)$(CC) $(CFLAGS) $(COMMON_LIBS) -o $(BUILD_PATH)/$@ $^

.PHONY: install
install:
	$(SILENCE)mkdir -p $(DESTDIR)/sbin
	$(SILENCE)install $(BUILD_PATH)/$(APP_NAME) $(DESTDIR)/sbin/


.PHONY: clean
clean:
	$(SILENCE)rm -rf $(BUILD_PATH)

