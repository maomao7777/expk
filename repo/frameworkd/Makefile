# Main Makefile to execute all subdirectory Makefiles
SUBDIRS := $(wildcard */)
TARGET ?= all

.PHONY: $(TARGET) clean install $(SUBDIRS)

$(TARGET): $(SUBDIRS)

$(SUBDIRS):
	@echo "Entering directory $@"
	@$(MAKE) -C $@ $(TARGET)
	@echo "Leaving directory $@"

clean:
	@for dir in $(SUBDIRS); do \
		echo "Cleaning in $$dir"; \
		$(MAKE) -C $$dir clean; \
	done
install:
	@for dir in $(SUBDIRS); do \
		echo "install in $$dir"; \
		$(MAKE) -C $$dir install; \
	done
