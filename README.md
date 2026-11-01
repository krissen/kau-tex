# kau-tex

LaTeX-paket för att efterlikna Karlstads universitets grafiska profil.

Det här är mina personliga anpassningar, inte ett officiellt KAU-paket och
inte kanoniskt för någon annan. Jag strävar efter att följa KAU:s grafiska
profil men gör medvetna avsteg där jag finner det lämpligt; använd på eget
ansvar.

## Implemented

| Subproject | Package | Notes |
|---|---|---|
| `kaulogo` | `kaulogo` | bundled KAU logo files, installed in TEXMF; see `kaulogo/NOTICE.md` |
| `kaucolors` | `kaucolors` | 2025 profile colour tokens (best effort) |
| `kaurubriker` | `kaurubriker`, `kau_rubriker` | heading font chain with fallbacks; `kau_rubriker` is a compatibility wrapper |
| `kau-style` | `kau-style` | class-agnostic core: `\kausetup`, metadata, margins, logo accessors, `craneorange` compatibility |
| `kau-firstpage` | `kau-firstpage` | logo/footer/first-page helpers for text classes, plus the legacy `\kaustyle*` wrappers |
| `beamerthemeSola` | `beamerthemeSola`, `beamerthemeSingaporeKAU` | miniframes, yellow header shading, title page with logo and extra logos; `SingaporeKAU` is a compatibility wrapper |
| `beamerthemeKAUposter` | `beamerthemeKAUposter`, `beamerthemeKAUposterNOLOGO` | poster themes; the NOLOGO variant builds on the main theme |
| `sola-floral` | `sola-floral` | Sola adaptation of `beamer-floral`; requires the krissen/tikz-flora fork |

The themes require `kau-style` (which loads `kaucolors`); no theme defines
its own `kaugul` or depends on `craneorange`. `tangocolors` (TeX Live) is
used by the poster themes.

`sola-floral` bygger på `beamer-floral` och `krissen/tikz-flora`. För lokal
kontroll kan en icke versionshanterad `local.mk` peka ut lokala checkouts:

```make
BEAMER_FLORAL := /path/to/beamer-floral
TIKZFLORA := /path/to/tikz-flora
```

Utan `local.mk` används de kopior som finns installerade i TeX-trädet.

Section dividers are opt-in:

```tex
\usetheme[sections=dividers]{Sola}  % one divider per \section
\kausectionpage                    % or a single divider
\kausectionpage[Custom title]      % single divider, custom title
```

The KAU logo is bundled in `kaulogo` and installed into TEXMF, so
`\includegraphics{kau_logga.pdf}` works from any document.
`kau-style` defaults to it; override with `\kausetup{logo=...}`. The logo
is a KAU trademark and is not LPPL-licensed; see `kaulogo/NOTICE.md`.

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
