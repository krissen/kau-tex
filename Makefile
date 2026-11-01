SHELL := /bin/sh
SUBPROJECTS := kaulogo kaucolors kaurubriker kau-style kau-firstpage beamerthemeSola beamerthemeKAUposter sola-floral
TEXMFHOME ?= $(HOME)/Library/texmf

# sola-floral builds on beamer-floral and the krissen/tikz-flora fork.
BEAMER_FLORAL ?= $(HOME)/dev/beamer-floral
TIKZFLORA ?= $(HOME)/dev/tikz-flora
export TEXINPUTS := $(BEAMER_FLORAL)//:$(TIKZFLORA)/tex//:$(TEXINPUTS)
export FLORA_LUA := $(TIKZFLORA)/lua
CHECKTEXMF := $(CURDIR)/.check-texmf

.DEFAULT_GOAL := check
.PHONY: check save install clean deps

# beamer-floral and tikzflora are not l3build projects of this repo; place
# them in the check tree so the sola-floral test can load them.
deps:
	@mkdir -p "$(CHECKTEXMF)/tex/latex/beamer-floral" "$(CHECKTEXMF)/tex/latex/tikzflora"
	@cp "$(BEAMER_FLORAL)"/*.sty "$(CHECKTEXMF)/tex/latex/beamer-floral/"
	@cp "$(TIKZFLORA)/tex/tikzflora.sty" "$(TIKZFLORA)/tex/tikzflora-boot.lua" "$(CHECKTEXMF)/tex/latex/tikzflora/"
	@cp -R "$(TIKZFLORA)/lua" "$(CHECKTEXMF)/tex/latex/tikzflora/"

check:
	rm -rf "$(CHECKTEXMF)"
	@set -e; for d in $(SUBPROJECTS); do \
	  ( cd $$d && l3build install --texmfhome "$(CHECKTEXMF)" >/dev/null ); \
	done
	@$(MAKE) deps
	@set -e; for d in $(SUBPROJECTS); do \
	  echo "== $$d"; ( cd $$d && TEXMFHOME="$(CHECKTEXMF)" l3build check ); \
	done

# TEST=<name> make save
save:
	@set -e; for d in $(SUBPROJECTS); do ( cd $$d && l3build save -e luatex $(TEST) ); done

install:
	@set -e; for d in $(SUBPROJECTS); do ( cd $$d && l3build install --texmfhome "$(TEXMFHOME)" ); done

clean:
	@for d in $(SUBPROJECTS); do ( cd $$d && l3build clean ); done
