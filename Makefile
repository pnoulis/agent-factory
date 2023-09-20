#!/usr/bin/make

#	The shell that is going to execute the recipies.
SHELL									 = /usr/bin/bash
#	Backtrack changes so that the directory tree does not
#	contain incomplete changes.
.DELETE_OR_ERROR:
#	Default target to run against.
.DEFAULT_GOAL	         := all

PKGDIR = .

SUBMODULES = $(PKGDIR)/software

all:
	@echo No target

pull-git:
	git submodule init
	git submodule update

push-git:
	$(foreach submodule,$(SUBMODULES), )

pull-gdrive:
# --update skip files that are newer on the destination
	rclone copy \
	--update \
	'gdrive:agent-factory' $(PKGDIR)

push-gdrive:
# --update skip files that are newer on the destination
	rclone copy \
	--exclude-from=$(PKGDIR)/.rcloneignore \
	--update \
	$(PKGDIR) 'gdrive:agent-factory' \

