PREFIX ?= /usr
DESTDIR ?=
LIBDIR ?= $(PREFIX)/lib
SYSTEM_EXTENSION_DIR ?= $(LIBDIR)/password-store/extensions
MANDIR ?= $(PREFIX)/share/man
BASHCOMPDIR ?= /etc/bash_completion.d

all:
	@echo "pass-oauth2 is a shell script and does not need compilation, it can be simply executed."
	@echo ""
	@echo "To install it try \"make install\" instead."
	@echo
	@echo "To run pass oauth2 one needs to have some tools installed on the system:"
	@echo "     password store"

install:
	@install -v -d "$(DESTDIR)$(MANDIR)/man1"
	@install -v -m 0644 pass-oauth2.1 "$(DESTDIR)$(MANDIR)/man1/pass-oauth2.1"
	@install -v -d "$(DESTDIR)$(SYSTEM_EXTENSION_DIR)/"
	@install -v -m0755 oauth2.bash "$(DESTDIR)$(SYSTEM_EXTENSION_DIR)/oauth2.bash"
	@install -v -d "$(DESTDIR)$(BASHCOMPDIR)/"
	@install -v -m 644 pass-oauth2.bash.completion  "$(DESTDIR)$(BASHCOMPDIR)/pass-oauth2"
	@echo
	@echo "pass-oauth2 is installed succesfully"
	@echo

uninstall:
	@rm -vrf \
		"$(DESTDIR)$(SYSTEM_EXTENSION_DIR)/oauth2.bash" \
		"$(DESTDIR)$(MANDIR)/man1/pass-oauth2.1" \
		"$(DESTDIR)$(BASHCOMPDIR)/pass-oauth2"

lint:
	shellcheck -s bash oauth2.bash

.PHONY: install uninstall lint
