---
id: rkdoc-update-site-docs-on-how-unnamed-ids-are-7e4bad42
short-id: '7'
title: Update site docs on how unnamed ids are minted
priority: 2
labels:
- fix-idea-auto-id-drift
deps: []
closed: true
---
Touches: content/reference.typ, content/faq.typ

## Why

This site documents `@rookery/core`'s auto-id scheme, and that scheme is
changing in the `rookery` repo (`/home/lox/code/_fcl/rookery`, its own tracker).
The old scheme minted a different id every time a stored body was re-rendered by
a `#window` or a minted page; the replacement makes an unnamed note's id a pure
function of its authored call site.

**This issue WAITS on that package change.** Do not start it until
`@rookery/core:0.1.0`'s readme describes the new scheme — check
`/home/lox/code/_fcl/rookery/core/0.1.0/readme.md`, section
`## Unnamed notes: where their ids come from`. If that heading is still
`## Unnamed notes: ids derived from title`, the package has not landed yet: stop
and report that, rather than writing the new rule speculatively.

The new rule, to be confirmed against that readme before writing:

- An unnamed `#idea` with a `title:` mints `idea:<slug of the title>` and
  nothing else — no counter, no collision suffix.
- An unnamed `#idea` with no title mints `idea:<container>-<k>`, where
  `<container>` is the enclosing note's bare id, or the page's handle with `:`
  replaced by `-` when the note is top-level, and `<k>` counts unnamed notes
  within that container from 1.
- Two unnamed notes that slug to the same id are a build error naming both,
  telling the author to pin one — not a silent `-<n>` suffix.
- An id no longer depends on document order, so reordering sections does not
  renumber anything.

## Steps

1. Fix the `#idea` argument table's description of `name:`. Anchor:

   ```
   rg -n 'a kebab-case form of the idea' /home/lox/code/_fcl/rookery.ohrg.org/content
   ```

   One hit, `content/reference.typ` line 334 as of filing. It reads
   `it is derived using a kebab-case form of the idea's `title` and/or a
   counter.` — `and/or a counter` is the part that is now wrong. State the two
   cases explicitly instead: a slug of the title where there is one, a
   container-scoped ordinal where there is not.

2. Fix `#ideate`'s `name:` row. Anchor:

   ```
   rg -n 'Defaults to #type-auto, the package counter' /home/lox/code/_fcl/rookery.ohrg.org/content
   ```

   One hit, `content/reference.typ` line 428 as of filing. `the package counter`
   no longer names anything; replace it with the default the package now uses,
   read off core's readme.

3. Fix the FAQ's claim about sequential codes. Anchor:

   ```
   rg -n 'if you prefer not to use sequential codes' /home/lox/code/_fcl/rookery.ohrg.org/content
   ```

   One hit, `content/faq.typ` line 63 as of filing, in the Forester comparison
   bullet list. Ids are no longer sequential codes; reword the contrast so it
   still says what it means — that rookery lets you pin a human-readable,
   semantic id rather than accept a generated one.

4. Sweep for anything else that describes the old scheme:

   ```
   rg -n 'counter|sequential|renumber' /home/lox/code/_fcl/rookery.ohrg.org/content
   ```

   Read every hit and fix the ones about ids. Hits about citation numbering
   (`content/concepts.typ` has one, `Citation numbering is rookery-wide`) are
   unrelated — leave them.

## NON-GOALS

- Do not add a new page, a new note, or a new section. This is a correction to
  prose that exists.
- Do not document the package's internals — no state names, no `_scope`. The
  site documents the author-facing surface.
- Do not touch `@rookery/core` itself, or anything under
  `~/.cache/typst/packages/`.
- Do not re-pin or rename any of the site's own notes.

## VERIFY

1. The site builds clean from the repo root: `rheo compile .` must succeed and
   print no warning about convergence:

   ```
   rheo compile . 2>&1 | grep -c 'did not converge\|did not stabilize'
   ```

   Expected output: `0`.

2. The stale claims are gone. Each must print nothing:

   ```
   rg -n 'and/or a counter' /home/lox/code/_fcl/rookery.ohrg.org/content
   rg -n 'the package counter' /home/lox/code/_fcl/rookery.ohrg.org/content
   rg -n 'sequential codes' /home/lox/code/_fcl/rookery.ohrg.org/content
   ```

3. Open `build/html/reference.html` and read the `name:` rows for `#idea` and
   `#ideate`. Each must describe what an unnamed note's id actually is, and the
   two must agree with each other.