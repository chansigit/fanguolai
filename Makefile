BINARY = fanguolai
SOURCES = Sources/fanguolai/main.swift \
          Sources/fanguolai/Accessibility.swift \
          Sources/fanguolai/Config.swift \
          Sources/fanguolai/Locale.swift \
          Sources/fanguolai/EventTap.swift \
          Sources/fanguolai/Daemon.swift
INSTALL_DIR = /usr/local/bin

.PHONY: build install uninstall clean

build:
	swiftc -O -o $(BINARY) $(SOURCES) -framework ApplicationServices -framework CoreGraphics -framework Foundation

install:
	@test -x $(BINARY) || (echo "Build $(BINARY) first with 'make build'"; exit 1)
	install -m 755 $(BINARY) $(INSTALL_DIR)/$(BINARY)
	@echo "Installed to $(INSTALL_DIR)/$(BINARY)"

uninstall:
	rm -f $(INSTALL_DIR)/$(BINARY)
	@echo "Uninstalled"

clean:
	rm -f $(BINARY)
