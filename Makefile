SHELL := /bin/sh
SUBPROJECTS := kaucolors kaurubriker beamerthemeSingaporeKAU beamerthemeKAUposter
TEXMFHOME ?= $(HOME)/Library/texmf

.PHONY: check save install clean

check:
	@set -e; for d in $(SUBPROJECTS); do echo "== $$d"; ( cd $$d && l3build check ); done

# TEST=<name> make save
save:
	@set -e; for d in $(SUBPROJECTS); do ( cd $$d && l3build save -e luatex $(TEST) ); done

install:
	@set -e; for d in $(SUBPROJECTS); do ( cd $$d && l3build install --texmfhome "$(TEXMFHOME)" ); done

clean:
	@for d in $(SUBPROJECTS); do ( cd $$d && l3build clean ); done
