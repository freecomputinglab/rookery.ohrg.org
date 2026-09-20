# rookery.ohrg.org

Documentation site for [`@rookery/core`](https://github.com/freecomputinglab/rookery),
built with [Rheo](https://rheo.ohrg.org) — and written with rookery.

## Getting started 

With [Rheo installed](https://rheo.ohrg.org/getting-started), run:

```sh
just watch   # live-rebuild and open
just build   # one-shot HTML into build/html/
```

`rheo.toml`'s `[packages.rookery]` table pins `@rookery/core` to a remote
repository and branch. 


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
| `fonts/` | Berkeley Mono, four faces (self-hosted, gitignored). |
| `Justfile` | the `watch` / `build` / `fonts` recipes above |
| `build.sh` | the CI build: fetches Rheo and the fonts, then runs `rheo compile` |
| `netlify.toml` | points Netlify at `build.sh` and `build/html` |
| `rheo.toml` | the site's Rheo config: content dir, spine exclusions and prelude, html assets, the package pin |


