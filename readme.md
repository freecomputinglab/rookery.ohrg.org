# rookery.ohrg.org

Documentation site for [`@rheo/rookery`](https://github.com/lachlankermode/rheo-packages),
built with [Rheo](https://rheo.ohrg.org) — and written with the package it
documents, so every note on it is a real `#idea` and every page under `notes/`
was minted from one.

```sh
just watch   # live-rebuild and open
just build   # one-shot HTML into build/
```

`@rheo/rookery:0.1.0` resolves from the Typst package cache; on this machine
the whole `rheo-packages` repo is symlinked in as the `rheo` namespace, so
edits to the package land here on the next rebuild with no publish step.

## Layout

| path | role |
| --- | --- |
| `content/template.typ` | site chrome, and the single place rookery is configured — prefix, theme, `ref-rule` |
| `content/index.typ` | the notes themselves, and views of them |
| `content/guide/intro.typ` | a nested vertebra, so cross-page hrefs have to resolve one level deeper |
| `content/about.typ` | about |
| `style.css` | site styling; the package's own CSS is injected by rheo |
| `fonts/` | Berkeley Mono, four faces (self-hosted; see below) |

Two families, split by what a thing is rather than where it sits. **Berkeley
Mono** is site furniture and identifiers — the wordmark, the nav, and a note's
`[idea:etal]` id — marking the parts of the page that are machinery rather
than writing. Nav entries and ids share one size, being the same kind of small
mono label. **Inter** is everything that is writing: every heading, and a
note's own title, which is its name.

Small-caps belongs to Inter only — in a monospace face the browser synthesises
them, scaling capitals down to the wrong weight for the rest of the face, so
Berkeley Mono is set upper outright where uppercase is wanted. An id is set
neither way: `[idea:etal]` is meant to be copied verbatim into `#view("...")`,
and a reader retyping what an uppercased id appeared to say would get it
wrong.

Inter is fetched from Google Fonts, matching rheo.ohrg.org and ohrg.org.
Berkeley Mono is self-hosted because it is licensed and on no CDN — and since
rheo copies no static directories (`css_stylesheet` is its only html asset
key), `just build` copies `fonts/` into `build/html/` after compiling, the same
copy cftw.ohrg.org makes in its `build.sh`. Until it has run, the wordmark, nav
and ids fall back to the generic `monospace`.

`template.typ` is a library, not a page, so `rheo.toml` excludes it from the
spine — otherwise every `.typ` under `content/` compiles to its own page.

The template exists mainly to solve one requirement once: `#show: rookery` has
to be applied in **every** vertebra that uses the package, since Typst imports
are per-file, and the prefix and theme are each one document-wide value that
every vertebra must agree on. A page writes `#show: template.with(...)` and
gets the chrome and the rookery setup together.

This site started as the `demo/rheo/` directory inside the package repo and
was moved out once it outgrew being a test fixture. The package still ships
`demo/pure/`, which is the same features under plain `typst compile` with no
rheo at all.
