---
id: rkdoc-say-that-a-missing-footnote-import-f3029634
short-id: f3
title: Say that a missing footnote import fails the build
priority: 1
labels:
- fix-footnote-import-panic
deps: []
closed: true
---
Writing a Typst `#footnote` inside an `#idea` without importing rookery's own
`footnote` is a hard build error in `@rookery/core` — it panics with a message
naming the import to add. This site tells authors to import it but never says
what happens if they don't, so the one page an author reaches for when the
build stops says nothing about the stop.

Touches: content/concepts.typ, content/reference.typ

## What core does now

The check lives in `core/0.1.0/src/idea.typ`. Verify it before editing:

```bash
rg -n -B6 'to your import' /home/lox/code/_fcl/rookery/core/0.1.0/src/idea.typ
```

One hit as of filing, `core/0.1.0/src/idea.typ:403`, inside a `panic(..)` that
fires when `_std-footnotes(body).len() > 0` — that is, when an idea's body
contains a footnote built by Typst's own `#footnote` rather than rookery's. The
message reads:

```
@rookery/core: `#footnote` inside an idea is Typst's, not rookery's — its body
would land in the page's endnote section instead of this idea's Footnotes
block. Add `footnote` to your import: `#import "@rookery/core:0.1.0": idea,
footnote`.
```

If that command prints nothing, the check is not on the pinned branch —
**stop and report that** rather than documenting a failure mode the package
does not have.

The package's readme states the contract in its "Footnotes" section:

```bash
rg -n -B2 -A8 'has to be imported to take effect' /home/lox/code/_fcl/rookery/core/0.1.0/readme.md
```

Three facts it gives, all of which the site is currently missing:

1. Typst imports are **per file**, so every vertebra that writes a footnote
   needs `footnote` in its own import list — the same way each one needs the
   template for the `ref` rule. Importing it in one file does not cover the
   next.
2. Omitting it **used to be silent** (the body went to the page's endnote
   section, numbered page-wide, and the idea rendered no Footnotes block at
   all). It is now a build error that names the import to add.
3. A footnote in ordinary page prose, **outside** any idea, is untouched by the
   check and still behaves exactly as Typst's does. The site already says this
   correctly in both places and it needs no edit.

**Scope note, read this before deciding how much to write.** This check is
older than the recent batch of core changes — it did not arrive with them. It
is filed because the sweep found the site silent on it, not because it is fresh
drift. Keep the edit proportionate: two sentences, not a new section.

## The sites

Two, one per page. Each anchor printed exactly one hit when this was filed;
line numbers drift, so resolve by running the anchor.

1. **The `footnotes` concept.** Anchor:

   ```bash
   rg -n --fixed-strings 'So that rookery can track them correctly' content
   ```

   One hit, `content/concepts.typ:97` as of filing: *"So that rookery can track
   them correctly, you need to use the `footnote` function imported from rookery
   in ideas, rather than the Typst native function:"*, introducing the code
   sample below it. It states the requirement and stops.

2. **The `#footnote` reference note.** Anchor:

   ```bash
   rg -n --fixed-strings 'Import it alongside' content/reference.typ
   ```

   One hit, `content/reference.typ:1029` as of filing, in the opening paragraph
   of `#reference(<footnote-reference>, title: [`#footnote`])[` (that
   `#reference` call is the landmark, at line 1027). The paragraph reads
   *"Rookery's own `#footnote`, which shadows Typst's and scopes a note to the
   idea it is written in. Import it alongside `#idea` and write footnotes
   exactly as before — the single positional argument is the footnote's body."*

## The steps

1. In `content/concepts.typ`, extend the sentence at the anchor (or add one
   after it) so an author learns that forgetting the import stops the build
   with a message naming it, and that the import is needed **in every file**
   that writes a footnote, because Typst imports are per-file.
2. In the `#footnote` reference note in `content/reference.typ`, add the same
   two facts in the reference register — one clause on the per-file import, one
   on the build error. Put it with the existing import sentence rather than at
   the end of the note; the note's closing paragraph is about the outside-an-
   idea fallback and should stay last.
3. Read both passages through afterwards and confirm neither now implies that
   omitting the import merely degrades the output. It does not — it fails the
   build.

## Non-goals

- Do not quote the panic message verbatim in the site's prose. Say that the
  build stops and that the error names the import; a message string copied into
  documentation goes stale the first time it is reworded upstream.
- Do not change what either page says about footnotes **outside** an idea
  falling back to Typst's own behaviour. That is still correct.
- Do not touch the `limit`/window footnote behaviour in either file — a separate
  bird covers that and editing it here would collide with that flight.
- Do not touch `content/concepts.typ:106-107` (idea-local numbering), which is
  correct.
- Do not add a new concept, a new reference note, or a new section.
- Do not document `_std-footnotes` or any other internal helper, and do not
  edit the sibling package repo `/home/lox/code/_fcl/rookery`.

## VERIFY

1. Both pages now mention the failure. Each must print at least one hit:

   ```bash
   rg -n -i 'build|error|fails' content/concepts.typ | rg -n -i 'footnote|import'
   rg -n -i 'per.file|every file|each file' content/reference.typ
   ```

   If the wording you chose does not match these greps, say so and quote the
   sentences instead — assert on the meaning, not on a phrasing this bird
   guessed in advance.

2. Quote both edited passages in your flight report.

3. The site builds:

   ```bash
   cd /home/lox/code/_fcl/rookery.ohrg.org && just build
   ```

   Report the exit status. Inside a bd flight workspace `just build`'s
   `cp fonts/*.ttf` step always fails, because `fonts/*.ttf` is gitignored and a
   flight has no `fonts/` directory — run `rheo compile . --html` there instead
   and report ITS exit status, which is the real check.