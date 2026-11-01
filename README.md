# kau-tex

Karlstads universitet LaTeX packages. Public repository.

## Implemented

| Subproject | Package | Notes |
|---|---|---|
| `kaucolors` | `kaucolors` | canonical 2025 colour tokens |
| `kaurubriker` | `kaurubriker`, `kau_rubriker` | heading font chain with fallbacks; `kau_rubriker` is a compatibility wrapper |
| `kau-style` | `kau-style` | class-agnostic core: `\kausetup`, metadata, margins, logo accessors, `craneorange` compatibility |
| `kau-firstpage` | `kau-firstpage` | logo/footer/first-page helpers for text classes, plus the legacy `\kaustyle*` wrappers |
| `beamerthemeSingaporeKAU` | `beamerthemeSingaporeKAU` | miniframes, yellow header shading, title page |
| `beamerthemeKAUposter` | `beamerthemeKAUposter`, `beamerthemeKAUposterNOLOGO` | poster themes; the NOLOGO variant builds on the main theme |

The themes require `kaucolors`; no theme defines its own `kaugul` or
depends on `craneorange`. `tangocolors` (TeX Live) is used by the poster
themes.

## Still to do

- `krissen-document` wrappers forwarding to `kau-firstpage`.
- `beamertheme-floral-kau`: owned by the `floral` session; do not implement
  here until its API is stable.
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
