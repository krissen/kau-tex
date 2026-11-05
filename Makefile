SHELL := /bin/sh
SUBPROJECTS := kaulogo kaucolors kaurubriker kau-style kau-firstpage beamerthemeSola beamerthemeKAUposter sola-floral
TEXMFHOME ?= $(HOME)/Library/texmf

# sola-floral builds on beamer-floral and the krissen/tikz-flora fork. The
# tests run against these commits, fetched into .deps/ by `make fetchdeps`
# (CI and the pre-push hook do the same). Bumping a pin means re-saving the
# sola-floral expectations.
BEAMER_FLORAL_REF := e40656f7889bb9e634b8cb819ef1b83d4e889cad
TIKZFLORA_REF := a3553bf6e449026a2e2e62b16e10210e82e9c1ad
# To test against working checkouts instead, set the paths in an untracked
# local.mk:
#   BEAMER_FLORAL := /path/to/beamer-floral
#   TIKZFLORA := /path/to/tikz-flora
-include local.mk
DEPS := $(CURDIR)/.deps
ifeq ($(strip $(BEAMER_FLORAL)$(TIKZFLORA)),)
BEAMER_FLORAL := $(DEPS)/beamer-floral
TIKZFLORA := $(DEPS)/tikz-flora
FETCHDEPS := fetchdeps
endif

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
.PHONY: check checktree save install clean deps fetchdeps

# Clones once, then fetches only when a pin moves. A git hook exports
# GIT_DIR and friends for this repository; drop them for the clones.
fetchdeps:
	@set -e; unset GIT_DIR GIT_WORK_TREE GIT_INDEX_FILE GIT_PREFIX GIT_OBJECT_DIRECTORY; fetch() { \
	  [ -d "$$1/.git" ] || git clone -q --filter=blob:none --no-checkout "$$2" "$$1"; \
	  git -C "$$1" cat-file -e "$$3^{commit}" 2>/dev/null || git -C "$$1" fetch -q origin "$$3"; \
	  git -C "$$1" -c advice.detachedHead=false checkout -q --detach "$$3"; \
	}; \
	fetch "$(DEPS)/beamer-floral" https://github.com/krissen/beamer-floral.git $(BEAMER_FLORAL_REF); \
	fetch "$(DEPS)/tikz-flora" https://github.com/krissen/tikz-flora.git $(TIKZFLORA_REF)

# beamer-floral and tikzflora are not l3build projects of this repo; place
# them in the check tree so the sola-floral test can load them.
deps:
	@if [ -d "$(BEAMER_FLORAL)" ] && [ -d "$(TIKZFLORA)" ]; then \
	  mkdir -p "$(CHECKTEXMF)/tex/latex/beamer-floral" "$(CHECKTEXMF)/tex/latex/tikzflora"; \
	  cp "$(BEAMER_FLORAL)"/*.sty "$(CHECKTEXMF)/tex/latex/beamer-floral/"; \
	  cp "$(BEAMER_FLORAL)/beamer-floral.lua" "$(CHECKTEXMF)/tex/latex/beamer-floral/"; \
	  cp "$(TIKZFLORA)/tex/tikzflora.sty" "$(TIKZFLORA)/tex/tikzflora-boot.lua" "$(CHECKTEXMF)/tex/latex/tikzflora/"; \
	  cp -R "$(TIKZFLORA)/lua" "$(CHECKTEXMF)/tex/latex/tikzflora/"; \
	else \
	  echo "note: beamer-floral/tikzflora checkouts not found; using installed copies if present" >&2; \
	fi

# check and save run against the same tree: this repository's packages and
# the floral dependencies, installed into $(CHECKTEXMF).
checktree: $(FETCHDEPS)
	rm -rf "$(CHECKTEXMF)"
	@set -e; for d in $(SUBPROJECTS); do \
	  ( cd $$d && l3build install --texmfhome "$(CHECKTEXMF)" >/dev/null ); \
	done
	@$(MAKE) deps

check: checktree
	@failed=; for d in $(CHECKPROJECTS); do \
	  echo "== $$d"; ( cd $$d && TEXMFHOME="$(CHECKTEXMF)" l3build check $(CHECKTESTS) ) || failed="$$failed $$d"; \
	done; \
	if [ -n "$$failed" ]; then echo "failed:$$failed" >&2; exit 1; fi

# make save                              every test
# CHECKPROJECTS=<dir> TEST=<name> make save   one test
save: checktree
	@set -e; for d in $(CHECKPROJECTS); do ( cd $$d && \
	  tests="$(TEST)"; [ -n "$$tests" ] || tests=$$(cd testfiles && ls *.lvt | sed 's/\.lvt$$//'); \
	  TEXMFHOME="$(CHECKTEXMF)" l3build save -e luatex $$tests ); done

install:
	@set -e; for d in $(SUBPROJECTS); do ( cd $$d && l3build install --texmfhome "$(TEXMFHOME)" ); done

clean:
	@for d in $(SUBPROJECTS); do ( cd $$d && l3build clean ); done
