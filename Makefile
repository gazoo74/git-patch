#!/bin/sh
#
# Copyright (c) 2017 Gaël PORTAY <gael.portay@savoirfairelinux.com>
#
# This program is free software: you can redistribute it and/or modify
# the terms of the GNU General Public License as published by
# the Free Software Foundation, version 3.
#

PREFIX ?= /usr/local

all: git-patch.1.gz

man: git-patch.1.gz

alias:
	git config --global alias.last 'log -1 HEAD'
	git config --global alias.unstage 'reset HEAD --'
	git config --global alias.cached 'diff --cached'
	git config --global alias.fixup '!f() { git commit --fixup=$${1:-HEAD}; }; f'
	git config --global alias.autosquash 'rebase -i --autosquash --autostash'
	git config --global alias.upstream 'rev-parse --abbrev-ref --symbolic-full-name @{u}'
	git config --global alias.graph 'log --graph --oneline --decorate'
	git config --global alias.ahead '!f() { br="$$(git upstream)"; git graph $${br:+$$br..}$${1:-HEAD}; }; f'

install:
	install -d $(DESTDIR)$(PREFIX)/bin
	install -m 755 git-patch $(DESTDIR)$(PREFIX)/bin
	install -d $(DESTDIR)$(PREFIX)/share/man/man1/
	install -m 644 git-patch.1.gz $(DESTDIR)$(PREFIX)/share/man/man1/

uninstall:
	rm -rf $(DESTDIR)$(PREFIX)/bin/git-patch
	rm -rf $(DESTDIR)$(PREFIX)/share/man/man1/git-patch.1.gz

clean:
	rm -f git-patch.1.gz

%.1: %.1.adoc
	asciidoctor -b manpage -o $@ $<

%.gz: %
	gzip -c $^ >$@
