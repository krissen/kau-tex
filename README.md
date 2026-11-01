# kau-tex

LaTeX-paket för att efterlikna Karlstads universitets grafiska profil.

Det här är mina personliga anpassningar, inte ett officiellt KAU-paket och
inte kanoniskt för någon annan. Jag strävar efter att följa KAU:s grafiska
profil men gör medvetna avsteg där jag finner det lämpligt; använd på eget
ansvar.

## Implemented

| Subproject | Package | Notes |
|---|---|---|
| `kaucolors` | `kaucolors` | 2025 profile colour tokens (best effort) |
| `kaurubriker` | `kaurubriker`, `kau_rubriker` | heading font chain with fallbacks; `kau_rubriker` is a compatibility wrapper |
| `kau-style` | `kau-style` | class-agnostic core: `\kausetup`, metadata, margins, logo accessors, `craneorange` compatibility |
| `kau-firstpage` | `kau-firstpage` | logo/footer/first-page helpers for text classes, plus the legacy `\kaustyle*` wrappers |
| `beamerthemeSola` | `beamerthemeSola`, `beamerthemeSingaporeKAU` | miniframes, yellow header shading, title page with logo and extra logos; `SingaporeKAU` is a compatibility wrapper |
| `beamerthemeKAUposter` | `beamerthemeKAUposter`, `beamerthemeKAUposterNOLOGO` | poster themes; the NOLOGO variant builds on the main theme |

The themes require `kau-style` (which loads `kaucolors`); no theme defines
its own `kaugul` or depends on `craneorange`. `tangocolors` (TeX Live) is
used by the poster themes.

Section dividers are opt-in:

```tex
\usetheme[sections=dividers]{Sola}  % one divider per \section
\kausectionpage                    % or a single divider
\kausectionpage[Custom title]      % single divider, custom title
```

Title page extras:

```tex
\kausetup{
  logo          = kau/bilder/kau_logga.pdf,
  title-logos   = {partner-one.pdf,partner-two.pdf},
  contributors  = {Medverkande:\\ A. Person, Roll},
}
```

The KAU logo is drawn by default; switch it off with
`\usetheme[title-logo=false]{Sola}`. `\kautitlelogo{...}`,
`\kautitlecontributors{...}` and `\kautitleextra{...}` add content without
redefining the title page.

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
