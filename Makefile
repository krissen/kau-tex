SHELL := /bin/sh
SUBPROJECTS := kaucolors kaurubriker kau-style kau-firstpage beamerthemeSola beamerthemeKAUposter
TEXMFHOME ?= $(HOME)/Library/texmf
CHECKTEXMF := $(CURDIR)/.check-texmf

.PHONY: check save install clean

check:
	rm -rf "$(CHECKTEXMF)"
	@set -e; for d in $(SUBPROJECTS); do \
	  ( cd $$d && l3build install --texmfhome "$(CHECKTEXMF)" >/dev/null ); \
	done
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
