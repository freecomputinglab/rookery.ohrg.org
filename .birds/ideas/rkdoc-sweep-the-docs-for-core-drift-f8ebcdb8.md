---
id: rkdoc-sweep-the-docs-for-core-drift-f8ebcdb8
short-id: f8
title: Sweep the docs for core drift
priority: 2
labels:
- fix-core-docs-drift
deps: []
closed: false
---
This site documents `@rookery/core`'s author-facing surface, and that package
has just had a batch of behaviour and naming changes land upstream. Read the
whole site against what core actually does now, and **file a bird in this repo
for every place the documentation no longer matches**. This bird writes no
prose of its own — its deliverable is birds.

Touches: .birds/ideas/

There is nothing to edit under `content/`. `Touches:` names the tracker
directory only, because the whole output of this bird is `bd create` calls.
**Do not edit `content/`, `style.css`, `readme.md` or `rheo.toml` in this
flight.** Fixing the drift is the job of the birds you file, each of which a
later flight works on its own.

## Prerequisite — the upstream changes must have landed

The package lives in the sibling repo `/home/lox/code/_fcl/rookery`, and this
site pins `@rookery` to its `dev` branch (`rheo.toml`, `[packages.rookery]`).
Read the package's source directly at that path rather than waiting for a
build to pick it up. Confirm the batch is in before starting:

```bash
rg -n '_number-footnotes' /home/lox/code/_fcl/rookery/core/0.1.0/src/pure.typ
rg -n '_outbound-tag-selectors' /home/lox/code/_fcl/rookery/core/0.1.0/src/links.typ
rg -n 'ideate-name' /home/lox/code/_fcl/rookery/core/0.1.0/src/pure.typ
rg -n 'display-name' /home/lox/code/_fcl/rookery/core/0.1.0/src/idea.typ
rg -n 'idea-name-color' /home/lox/code/_fcl/rookery/core/0.1.0/src/theme.typ
```

Each should print at least one hit. If any prints nothing, that change has not
landed — **still do the sweep, but skip the sections resting on the missing
piece and say in your flight report which ones you skipped.** Do not file a
bird describing a surface that does not exist.

Note also that reading the package's source at that path is authoritative,
while a local `rheo compile .` of this site may not be: rheo caches git refs
under `~/.cache/rheo/git`, so a build can quietly keep using an older `dev`.
If you do build the site and its output contradicts the source you read, trust
the source and say so in your report.

## What changed upstream

Six changes, each with the source anchor that proves it:

1. **Footnotes are numbered while a note's body is built, not while the page is
   laid out.** `_footnoted` in `core/0.1.0/src/bib.typ` no longer steps a
   `counter("rheo-idea-fn-…")` inside a show rule; it calls the new
   `_number-footnotes` helper in `core/0.1.0/src/pure.typ`, which walks the
   body in document order and substitutes each marker as literal content.
   Anchor: `rg -n '_number-footnotes' /home/lox/code/_fcl/rookery/core/0.1.0/src`.
   The user-visible consequence is that a note's footnote numbers are now
   correct on the first render and identical everywhere the note appears,
   including inside a `#window`; previously they could resolve late or read
   `0`, and a large site emitted `did not converge` warnings. Idea-local
   numbering itself is unchanged — two ideas on one page may still each have a
   footnote `1`.
2. **A tag-selected `#window` now registers backlinks against the page it sits
   on.** `<rookery-window-mark>` in `core/0.1.0/src/window.typ` carries
   `tagged`, `match` and `filtered`, and `_page-links` in
   `core/0.1.0/src/outline.typ` resolves the tag predicate against the final
   registry. Anchor: `rg -n 'filtered' /home/lox/code/_fcl/rookery/core/0.1.0/src/window.typ`.
3. **A tag-selected `#window` written inside a note's body also registers
   backlinks from that note.** `_outbound-tag-selectors` in
   `core/0.1.0/src/links.typ` collects the selectors, `core/0.1.0/src/idea.typ`
   stores them on the registry record as `tag-links`, and
   `core/0.1.0/.marrow.typ` expands them, with a guard so a note never
   backlinks itself.
4. **The limits of that are now fixed and documented in the package's own
   readme**: a window passing `filter:` — alone or together with `tagged:` —
   registers no backlinks at all, because a filter is a function and cannot
   ride in metadata; `backlink: false` still suppresses everything; and a
   note's own origin page is excluded from its Backlinks, since the Context
   listing already names it. Anchor:
   `rg -n 'filter' /home/lox/code/_fcl/rookery/core/0.1.0/readme.md | rg -i backlink`.
5. **Three renames, id → name**, standardising the word for the thing that
   names a note: `#ideate-id` → `#ideate-name`, the `display-id:` argument →
   `display-name:`, and the CSS custom property `--idea-id-color` →
   `--idea-name-color`.
6. `_flatten` and `_body-at` in `core/0.1.0/src/transclusion.typ` lost a dead
   `id:` parameter. **Internal only — it appears in no documented surface, and
   is listed here so you can rule it out rather than hunt for it.**

## Two birds already exist — do not duplicate them

This repo already carries targeted birds for part of the above. Read both with
`bd show` before filing anything, and file nothing that either already covers:

- `rkdoc-drop-stale-tag-backlink-caveat-79ae6810` (short id `79`, label
  `fix-tag-window-backlinks`) covers the stale comment above the
  `#window(tagged: "alpha-package", limit: 1)` call in
  `content/packages/index.typ`, which claims tag-selected windows produce no
  Backlinks entry. That is change 2/3 above, in that one file only.
- `rkdoc-update-reference-for-the-name-renames-3a0d0b50` (short id `3`, label
  `fix-idea-name-terminology`) covers the code the reference page quotes —
  argument names, theme keys, CSS custom properties and code samples — in
  `content/reference.typ` and `style.css`. That is change 5 above, in those two
  files only.

Everything else is yours. In particular, neither existing bird covers change 1
at all, and neither covers changes 2, 3 or 4 outside
`content/packages/index.typ`.

## The steps

1. Read `bd show 79` and `bd show 3` in this repo in full, so you know exactly
   what is already claimed.
2. Read the package's current behaviour from source. The files worth reading
   are `core/0.1.0/readme.md` (the author-facing contract, and the fastest way
   in), then `src/bib.typ`, `src/window.typ`, `src/outline.typ`, `src/links.typ`
   and `.marrow.typ` under `/home/lox/code/_fcl/rookery/core/0.1.0/` for the
   mechanisms behind it.
3. Sweep this site's pages against it. All of them, in this order — the counts
   are hits as of filing, to tell you where to spend your attention, not a
   target:

   ```bash
   cd /home/lox/code/_fcl/rookery.ohrg.org
   rg -n -i 'footnote' content/concepts.typ content/faq.typ content/reference.typ
   rg -n -i 'backlink' content style.css
   rg -n -i 'tagged|tag-selected' content
   rg -n 'ideate-id|display-id|idea-id-color' content style.css readme.md
   ```

   `content/concepts.typ` has 14 footnote mentions and `content/reference.typ`
   12, concentrated around `content/concepts.typ:95-115` (the `footnotes`
   concept note) and `content/reference.typ:1025-1039` (the `#footnote`
   reference entry). `backlink` has 13 hits in `content/reference.typ`, 3 in
   `content/concepts.typ`, and one each in `content/index.typ`,
   `content/faq.typ`, `content/packages/index.typ` and
   `content/packages/pinboard.typ`, plus 2 in `style.css`. `ideate-id` and
   `idea-id-color` have 2 hits each, both in `content/reference.typ`.
   Do not skip `content/packages/*.typ` or `readme.md` because the counts there
   are low.
4. For each genuine mismatch, file a bird in **this** repo (`cd
   /home/lox/code/_fcl/rookery.ohrg.org` first, so it lands in the `rkdoc`
   project and not the package's tracker). Write each one to the standard of
   the `bird-quality` skill — load that skill and follow it. In particular
   every bird you file needs its own `Touches:` line, a search anchor with the
   `rg` command that finds it and what that command printed when you ran it,
   numbered steps, stated non-goals, and a VERIFY section using this repo's own
   tooling (`just build`, which runs `rheo compile . --html`, plus `rg`
   assertions on the prose). Reuse the existing labels where a mismatch belongs
   to one of them — `fix-tag-window-backlinks` for changes 2/3/4 and
   `fix-idea-name-terminology` for change 5 — and use
   `fix-footnote-number-at-construction` for anything arising from change 1.
   Because the site's prose is re-wrapped freely, never write a VERIFY
   assertion that greps a whole sentence or asserts a hit count the bird's own
   steps change.
5. Where a page is already correct, file nothing. A sweep that files three
   accurate birds is a better result than one that files ten padded ones.

## Non-goals

- **Do not edit any file under `content/`, nor `style.css`, `readme.md` or
  `rheo.toml`.** This bird files birds; it does not fix documentation.
- Do not file birds against the sibling `rookery` package repo. Everything you
  file goes in this repo's tracker.
- Do not re-file what birds `79` and `3` already cover, and do not edit,
  re-scope or close either of them.
- Do not touch the uncommitted change already sitting in this repo's working
  copy.
- Do not document `_flatten`'s dropped `id:` parameter, or any other internal
  helper. Only the author-facing surface is in scope.
- Do not restructure the site, retitle pages, or file birds about prose style,
  typos or layout. A mismatch with core's actual behaviour is the only thing
  that earns a bird here.

## VERIFY

1. `bd list` in `/home/lox/code/_fcl/rookery.ohrg.org` shows every bird you
   filed, each with a label from step 4.
2. For each bird you filed, `bd show <id>` prints a `Touches:` line and a
   VERIFY section, and the `rg` anchor it quotes returns a hit when run.
3. `rg -n 'ideate-id|display-id|idea-id-color' content style.css readme.md`
   returns only hits that bird `3` already claims, or hits covered by a bird
   you filed. Name any leftover explicitly in your flight report.
4. `git status`-style checks are forbidden here; instead confirm you edited no
   documentation by running `rg -n 'rookery' content/index.typ` and observing
   the page reads as it did — and simply state in your report that the only
   files you wrote are under `.birds/`.
5. Your flight report lists every bird you filed with its id and one-line
   rationale, and every place you looked and found correct.

If the sweep finds nothing to file, that is a legitimate result: alight with
`--allow-empty` and say what you checked.