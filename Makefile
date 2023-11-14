#!/usr/bin/make

# Project
project_name=agent-factory
project_version=0.0.1
project_license='UNLICENSED'
project_repository='https://github.com/pnoulis/agent-factory'
project_homepage='https://github.com/pnoulis/agent-factory#README'
project_bugreport='https://github.com/pnoulis/agent-factory/issues'
project_description='Infrastructure for agent-factory project'
project_keywords='agent-factory,af,infrastructure'
project_author='pavlos noulis <pavlos.noulis@gmail.com> (https://github.com/pnoulis)'

#	The shell that is going to execute the recipies.
SHELL									 = /usr/bin/bash
# Strict mode
.SHELLFLAGS := -eu -o pipefail -c
#	Backtrack changes so that the directory tree does not
#	contain incomplete changes.
.DELETE_OR_ERROR:
#	Default target to run against.
.DEFAULT_GOAL	         := all
# All lines in a recipe are passed to a single invocation of the SHELL
.ONESHELL:
.SECONDEXPANSION:
.EXPORT_ALL_VARIABLES:


# Programs and configuration
RCLONE = /usr/bin/rclone
RCLONE_GDRIVE = gdrive

PKGNAME = agent-factory
PKGDIR = .
PKGDIR_ABS = $(realpath -e $(PKGDIR))

SUBMODULES = $(PKGDIR)/software
DEPARTMENTS = $(PKGDIR)/software $(PKGDIR)/designs

all:
	@echo No target

pull-git:
	git submodule init
	git submodule update

push-git:
	@for submodule in $(SUBMODULES); do
	echo $$submodule
	done

pull-cloud:
# --update skip files that are newer on the destination
	rclone copy \
	--update \
	--progress \
	'$(RCLONE_GDRIVE):$(PKGNAME)' $(PKGDIR)

push-cloud:
# --update skip files that are newer on the destination
	@for department in $(DEPARTMENTS); do
	$(RCLONE) copy \
	--update \
	--progress \
	$$department/cloud "$(RCLONE_GDRIVE):$(PKGNAME)/$${department#*/}"
	done

run: file=
run: $$(file)
	@if [[ "$${file:-}" == "" ]]; then
	echo 'Usage: `make run file [args]`'
	exit 1
	fi
	extension="$${file##*.}"
	case $$extension in
	sh)
	$(SHELL) $$file $(args)
	;;
	*)
	echo "Unrecognized extension: $$extension"
	echo 'Failed to `make $@ $^`'
	;;
	esac

.DEFAULT:
	@if [ ! -f "$<" ]; then
	echo "Missing file $${file:-}"
	exit 1
	fi


help:
	@line=$$(grep -n '^.PHONY:[[:space:]]*help' Makefile | cut -d':' -f1)
	tail Makefile --lines=+$$line

.PHONY: help
# Usage: `make help [command]`
.PHONY: run
# Usage: `make run file [args]`
.PHONY: push-cloud
.PHONY: pull-cloud
.PHONY: pull-git
.PHONY: push-git
.PHONY: all

