#!/usr/bin/make

# Project
pkg_name=agent-factory
pkg_version=0.0.1
pkg_license='UNLICENSED'
pkg_repository='https://github.com/pnoulis/agent-factory'
pkg_homepage='https://github.com/pnoulis/agent-factory#README'
pkg_bugreport='https://github.com/pnoulis/agent-factory/issues'
pkg_description='IE group agent-factory project'
pkg_keywords='Intelligent Entertainment,ie,IE,agent-factory,AF,af'
pkg_author='pavlos noulis <pavlos.noulis@gmail.com> (https://github.com/pnoulis)'

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


# Programs and their configuration
# ------------------------------
# Dotenv
dotenv=$(HOME)/bin/dotenv
dotenvdirs:=env/* config.env
dotenvfile:=.env
loadenv:=set -a; source $(dotenvfile)

# Cloud storage
cloud=scripts/gdrive.sh
cloudignore=-iregex '.*/\(sofia\)' -prune -o

# Directories
# ------------------------------
pkgdir=.
pkgdir_abs=$(realpath -e $(pkgdir))
depdir=$(pkgdir)/dep
usrdir=$(pkgdir)/usr

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
	@$(loadenv)
# pull temporary
	$(cloud) pull tmp tmp/cloud/
# pull root
	$(cloud) pull root cloud/
# pull the departments
	while IFS= read -r -d $$'\0' dep; do
	source="$${dep#*/}" # ./dep/software -> dep/software
	$(cloud) pull "$$source" "$${source}/cloud/"
	done < <(find $(depdir) -mindepth 1 -maxdepth 1 -type d -print0)
# pull the users
	while IFS= read -r -d $$'\0' usr; do
	source="$${usr#*/}"
	$(cloud) pull "$$source" "$${source}/cloud/"
	done < <(find $(usrdir) -mindepth 1 -maxdepth 1 -type d $(cloudignore) -print0)


push-cloud:
	@$(loadenv)
# push temporary
	$(cloud) push "tmp/cloud/" tmp
# push root
	$(cloud) push "cloud/" root
# push the departments
	while IFS= read -r -d $$'\0' dep; do
	destination="dep/$$(dirname "$${dep#*/*/}")" # ./dep/software/cloud -> dep/software
	$(cloud) push "$$dep/" "$$destination"
	done < <(find $(depdir) -maxdepth 2 -type d -name cloud -print0)
# push the users
	while IFS= read -r -d $$'\0' usr; do
	destination="usr/$$(dirname "$${usr#*/*/}")" # ./usr/pnoulis/cloud -> usr/pnoulis
	$(cloud) push "$$usr/" "$$destination"
	done < <(find $(usrdir) -maxdepth 2 -type d $(cloudignore) -name cloud -print0)

run: file=
run: dotenv $$(file)
	@if [[ "$${file:-}" == "" ]]; then
	echo 'Usage: `make run file [args]`'
	exit 1
	fi
	extension="$${file##*.}"
	$(loadenv)
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

dotenv: $(dotenvfile)

$(dotenvfile): $(dotenvdirs)
	$(dotenv) $^ | sort > $@

clean:
	rm -f .env
	rm -f .secrets

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
.PHONY: dotenv
