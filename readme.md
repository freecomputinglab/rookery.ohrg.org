# rookery.ohrg.org

Documentation site for [`@rookery/core`](https://github.com/freecomputinglab/rookery),
built with [Rheo](https://rheo.ohrg.org) — and written with the package it
documents, so every note on it is a real `#idea` and every page under `ideas/`
was minted from one.

## Getting it running

Install Rheo first: see [rheo.ohrg.org/getting-started](https://rheo.ohrg.org/getting-started).
Then, from a fresh clone, with nothing else to set up:

```sh
just watch   # live-rebuild and open
just build   # one-shot HTML into build/html/
```

`rheo.toml`'s `[packages.rookery]` table pins `@rookery/core` to a remote
repository and branch, so it resolves the same way for anyone who clones this
project — there is nothing to install into a local Typst package cache, and a
change to the package reaches this site only when that pin moves. Pointing the
pin at a local checkout instead is possible — give `repo` a filesystem path,
e.g. `repo = "/absolute/path/to/rookery"` — but that is a deliberate departure
from how this site actually resolves the package, not its default.

### Fonts

Berkeley Mono is licensed, so its TTFs are gitignored and a fresh clone does
not have them. The site builds and renders correctly without them, falling
back to the generic `monospace` — the wordmark, the nav, and an idea's name
are what change. `just fonts` copies them into the build when they are
present in `fonts/`, and prints a message and exits cleanly when they are not.
CI (`build.sh`) fetches them from a private repository first, then runs the
same copy.

## Layout

| path | role |
| --- | --- |
| `content/_lib/prelude.typ` | spliced into every vertebra by `rheo.toml`'s `[spine] prelude`; imports the package once and applies `template` so no page has to |
| `content/_lib/template.typ` | site chrome, and the single place rookery is configured — theme, `window-depth`, `idea-page-template`, bibliography |
| `content/_lib/types.typ` | shared type/shape definitions used across the site's pages |
| `content/index.typ` | the landing page, and the two foundational ideas the rest of the site windows onto |
| `content/concepts.typ` | what a rookery is made of: hatching, referencing, windowing, outlining |
| `content/reference.typ` | installing it, then the tables — configuration, theme, classes, properties |
| `content/faq.typ` | where rookery came from, and how it compares to forester and Kodama |
| `content/packages/` | nine pages under their own nav section, one per package built on rookery |
| `content/references.bib` | the one bibliography every citation on the site draws from |
| `style.css` | site styling; the package's own CSS is injected by rheo |
| `nav.js` | toggles the mobile nav's expanded state |
| `tables.js` | mirrors each table's headers onto its cells, for the card layout below 600px |
| `fonts/` | Berkeley Mono, four faces (self-hosted, gitignored; see above) |
| `Justfile` | the `watch` / `build` / `fonts` recipes above |
| `build.sh` | the CI build: fetches Rheo and the fonts, then runs `rheo compile` |
| `netlify.toml` | points Netlify at `build.sh` and `build/html` |
| `rheo.toml` | the site's Rheo config: content dir, spine exclusions and prelude, html assets, the package pin |

Every `#idea` on those pages also gets a minted page under `build/html/ideas/`,
and rookery mints `ideas/index.html` alongside them — a listing of the whole
rookery, on by default and left on here.

Two families, split by what a thing is rather than where it sits. **Berkeley
Mono** is site furniture and names — the wordmark, the nav, and a note's
`[idea:etal]` name — marking the parts of the page that are machinery rather
than writing. Nav entries and names share one size, being the same kind of
small mono label. **Inter** is everything that is writing: every heading, and
a note's own title, which is prose rather than machinery.

Small-caps belongs to Inter only — in a monospace face the browser synthesises
them, scaling capitals down to the wrong weight for the rest of the face, so
Berkeley Mono is set upper outright where uppercase is wanted. A name is set
neither way: `[idea:etal]` is meant to be copied verbatim into `#view("...")`,
and a reader retyping what an uppercased name appeared to say would get it
wrong.

Inter is fetched from Google Fonts, matching rheo.ohrg.org and ohrg.org.
Berkeley Mono is self-hosted because it is licensed and on no CDN — and since
rheo copies no static directories (`css_stylesheet` is its only html asset
key), `just build` needs `just fonts` run afterward to copy `fonts/` into
`build/html/`, the same copy cftw.ohrg.org makes in its `build.sh`. Until it
has run, the wordmark, nav and names fall back to the generic `monospace`.

`content/_lib/template.typ` is a library, not a page, so `rheo.toml` excludes
`_lib/**` from the spine — otherwise every `.typ` under `content/` compiles to
its own page.

The template exists mainly to solve one requirement once: `#show: rookery` has
to be applied in **every** vertebra that uses the package, since Typst imports
are per-file, and the prefix and theme are each one document-wide value that
every vertebra must agree on. `content/_lib/prelude.typ`, spliced into every
page by `[spine] prelude`, imports the package and applies
`#show: template.with(...)` once, so no page under `content/` has to do either
itself.

## What's worth copying from this site

A few patterns, if you're building your own Rheo + rookery site:

- **`[spine] prelude`** applies the template and the package imports once, in
  `content/_lib/prelude.typ`, instead of repeating a header in every page.
- **`_lib/**` excluded from the spine** is what keeps a library file — the
  template, shared types — from compiling into a page of its own.
- **`style.css` layers over the package's own CSS** rather than replacing it:
  rookery ships its own stylesheet, and this site's `style.css` adds site
  furniture (fonts, nav, layout) on top rather than reimplementing it.
