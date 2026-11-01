# kau-tex

Karlstads universitet LaTeX packages. Public repository.

## Implemented

| Subproject | Package | Notes |
|---|---|---|
| `kaucolors` | `kaucolors` | canonical 2025 colour tokens |
| `kaurubriker` | `kaurubriker`, `kau_rubriker` | heading font chain with fallbacks; `kau_rubriker` is a compatibility wrapper |
| `beamerthemeSingaporeKAU` | `beamerthemeSingaporeKAU` | miniframes, yellow header shading, title page |
| `beamerthemeKAUposter` | `beamerthemeKAUposter`, `beamerthemeKAUposterNOLOGO` | poster themes; the NOLOGO variant builds on the main theme |

The themes require `kaucolors`; no theme defines its own `kaugul` or
depends on `craneorange`. `tangocolors` (TeX Live) is used by the poster
themes.

## Still to do

- `kau-style`: the shared six-element style layer.
- `kau-firstpage`: the approved title page, with `krissen-document` wrappers
  forwarding to it.
- `beamertheme-floral-kau`: thin configuration over the separate
  `beamer-floral` repository.
- Section dividers (decide opt-in vs default).
- Full brand audit, document migration and removal of `craneorange`
  overrides.

## Build and test

```sh
make check
make install
```

## Licence

LPPL 1.3c, see `LICENSE`.
