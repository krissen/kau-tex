SHELL := /bin/sh
SUBPROJECTS := kaulogo kaucolors kaurubriker kau-style kau-firstpage beamerthemeSola beamerthemeKAUposter sola-floral
TEXMFHOME ?= $(HOME)/Library/texmf

# sola-floral builds on beamer-floral and the krissen/tikz-flora fork.
# Local checkouts are optional and belong in an untracked local.mk:
#   BEAMER_FLORAL := /path/to/beamer-floral
#   TIKZFLORA := /path/to/tikz-flora
BEAMER_FLORAL ?=
TIKZFLORA ?=
-include local.mk

ifneq ($(strip $(BEAMER_FLORAL)),)
export TEXINPUTS := $(BEAMER_FLORAL)//:$(TEXINPUTS)
endif
ifneq ($(strip $(TIKZFLORA)),)
export TEXINPUTS := $(TIKZFLORA)/tex//:$(TEXINPUTS)
export FLORA_LUA := $(TIKZFLORA)/lua
endif
CHECKTEXMF := $(CURDIR)/.check-texmf
CHECKPROJECTS ?= $(SUBPROJECTS)
CHECKTESTS ?=

.DEFAULT_GOAL := check
.PHONY: check save install clean deps

# beamer-floral and tikzflora are not l3build projects of this repo; place
# them in the check tree so the sola-floral test can load them.
deps:
	@if [ -d "$(BEAMER_FLORAL)" ] && [ -d "$(TIKZFLORA)" ]; then \
	  mkdir -p "$(CHECKTEXMF)/tex/latex/beamer-floral" "$(CHECKTEXMF)/tex/latex/tikzflora"; \
	  cp "$(BEAMER_FLORAL)"/*.sty "$(CHECKTEXMF)/tex/latex/beamer-floral/"; \
	  cp "$(TIKZFLORA)/tex/tikzflora.sty" "$(TIKZFLORA)/tex/tikzflora-boot.lua" "$(CHECKTEXMF)/tex/latex/tikzflora/"; \
	  cp -R "$(TIKZFLORA)/lua" "$(CHECKTEXMF)/tex/latex/tikzflora/"; \
	else \
	  echo "note: beamer-floral/tikzflora checkouts not found; using installed copies if present" >&2; \
	fi

check:
	rm -rf "$(CHECKTEXMF)"
	@set -e; for d in $(SUBPROJECTS); do \
	  ( cd $$d && l3build install --texmfhome "$(CHECKTEXMF)" >/dev/null ); \
	done
	@$(MAKE) deps
	@set -e; for d in $(CHECKPROJECTS); do \
	  echo "== $$d"; ( cd $$d && TEXMFHOME="$(CHECKTEXMF)" l3build check $(CHECKTESTS) ); \
	done

# TEST=<name> make save
save:
	@set -e; for d in $(SUBPROJECTS); do ( cd $$d && l3build save -e luatex $(TEST) ); done

install:
	@set -e; for d in $(SUBPROJECTS); do ( cd $$d && l3build install --texmfhome "$(TEXMFHOME)" ); done

clean:
	@for d in $(SUBPROJECTS); do ( cd $$d && l3build clean ); done
