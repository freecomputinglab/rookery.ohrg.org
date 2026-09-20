---
id: rkdoc-drop-four-past-tense-comments-7af20baa
short-id: 7a
title: Drop four past-tense comments
priority: 1
labels:
- drop-past-tense-comments
deps:
- blocked-by:rkdoc-document-the-missing-css-levers-893cba0b
closed: false
---
Four comments in this repository's Typst source describe the past rather than
the present: two cite package or engine versions as the moment something became
true, one says a thing is not done "any more", and one explains where a passage
"lived" before it moved. This project's rules exclude all four shapes, and one
of them points a reader at a file that does not exist.

Touches: content/_lib/template.typ, content/reference.typ

## The rule

From this project's `CLAUDE.md`: "**Describe the present.** Say what the code is
and why it is that way. Never what it used to be, what moved where, which
release changed it, or that something 'is gone'. 'The scorer lives in
`score.typ`' is worth a line; 'the scorer used to live in `tagquery.typ`' is
worth none."

## The four sites

```
rg -n "rookery 0\.4\.0|since rheo 0\.6\.0|any more|lived on" /home/lox/code/_fcl/rookery.ohrg.org/content
```

Four hits as of filing.

1. **`content/_lib/template.typ` line 5** — a comment naming "rookery 0.4.0's
   `theme.tags-color`". There is no 0.4.0; every package in the family is at
   `0.1.0`, which is what this file's own imports pin. Keep the fact — the per-tag
   colour comes from the package's `theme.tags-color` — and drop the version.

2. **`content/_lib/template.typ` lines 70-71** — "`spine-flat`'s `title`, which
   since rheo 0.6.0 is purely path-derived anyway". Keep the claim (it is
   path-derived), drop "since rheo 0.6.0". If it matters that this depends on a
   rheo behaviour, say that it does, without dating it.

3. **`content/_lib/template.typ` line 279** — "NO VERTEBRA APPLIES THIS BY HAND
   any more. `[spine] prelude` in `rheo.toml`...". The present-tense version is
   stronger and shorter: no vertebra applies this by hand, because the prelude
   does it. Drop "any more".

4. **`content/reference.typ` lines 382-383** — "The three written-out references
   lived on `content/packages/core.typ` until the package shelf was cut back".
   That file does not exist; a reader who greps for it finds nothing. Confirm:

   ```
   ls /home/lox/code/_fcl/rookery.ohrg.org/content/packages/
   ```

   Read the passage in full before editing — if the sentence exists only to
   explain the references' history, delete it outright. If it is doing real work
   (saying why those three references are written out rather than windowed),
   keep that reason in present tense and drop the account of where they were.

## Non-goals

- Do NOT change any Typst code, template logic, `#let` binding or `#show` rule
  in either file. Comments only.
- Do NOT go looking for other comments to rewrite. These four are the scope.
- Do NOT touch `style.css` — a separate bird owns its comments — or `readme.md`,
  which has its own.
- Do NOT rename any idea or change any `@idea:` reference. A broken reference
  fails the build.

## VERIFY

1. `rg -n "rookery 0\.4\.0|since rheo 0\.6\.0|any more|lived on" /home/lox/code/_fcl/rookery.ohrg.org/content`
   prints nothing.
2. `rg -n 'tags-color' /home/lox/code/_fcl/rookery.ohrg.org/content/_lib/template.typ`
   still prints at least one hit — the fact survived the version being dropped.
3. `rg -n 'spine-flat' /home/lox/code/_fcl/rookery.ohrg.org/content/_lib/template.typ`
   still prints at least one hit.
4. From the repository root, `just build` succeeds and prints a compilation
   summary.