---
id: rkdoc-document-how-footnotes-behave-in-a-b6613a1c
short-id: b6
title: Document how footnotes behave in a limited window
priority: 2
labels:
- fix-footnote-number-at-construction
deps: []
closed: true
---
`@rookery/core` now numbers a note's footnotes while its body is being built
rather than while the page is laid out, and that makes a `#window` carrying
`limit:` behave in a way this site documents nowhere. One sentence on
`content/concepts.typ` is now slightly false as a result, and the `limit`
argument entry in `content/reference.typ` is silent about it.

Touches: content/concepts.typ, content/reference.typ

## What core does now

Verify against the package's own source in the sibling repo
`/home/lox/code/_fcl/rookery` — this site pins `@rookery` to the `dev` branch
(`rheo.toml`, `[packages.rookery]`) and rheo caches git refs under
`~/.cache/rheo/git`, so a local build can quietly use an older `dev` than the
source you read. The source is authoritative.

```bash
rg -n '_number-footnotes' /home/lox/code/_fcl/rookery/core/0.1.0/src/pure.typ
```

Should print hits (the helper is defined around line 662). If it prints
nothing the change is not on that branch yet — **stop and report that** rather
than documenting behaviour the package does not have.

The behaviour to document is stated in the package's own readme, in its
"Footnotes" section and in the `limit:` discussion under "Referencing a note".
Read both before writing:

```bash
rg -n -A12 '^## Footnotes' /home/lox/code/_fcl/rookery/core/0.1.0/readme.md
rg -n -B4 -A14 'A footnote written inside the shown portion' /home/lox/code/_fcl/rookery/core/0.1.0/readme.md
```

The three facts they give:

1. A note's footnote numbers are now fixed the moment its body is assembled,
   so they are the same on every surface the note appears on — its hatching
   page, its minted page, and every `#window` on it. (Idea-local numbering
   itself is unchanged: two ideas on one page may still each have a footnote
   `1`. The site already says this correctly and it needs no edit.)
2. In HTML and EPUB, a `#window` with `limit:` lists **every** footnote in the
   note, not just the ones in the shown blocks — the tail is not discarded
   there, it sits collapsed behind the preview's disclosure. A footnote written
   inside the shown portion therefore renders **twice**: once bare, in the
   collapsed preview, picked up by whatever footnote handling encloses the
   window; and once more, correctly numbered, in the window's own list once the
   body unfurls.
3. Under a paged target (PDF), where the tail really is dropped, the block
   lists only the footnotes whose references survive the truncation — so a
   shortened note there never shows an entry with nothing pointing at it.

## The sites

Two, and each anchor printed exactly one relevant hit when this was filed.
Line numbers drift; resolve by running the anchor.

1. **The sentence that is now imprecise.** Anchor:

   ```bash
   rg -n --fixed-strings 'Ideas will show footnotes everywhere their content appears' content
   ```

   One hit, `content/concepts.typ:109` as of filing. It is the body of a
   footnote hanging off "Footnote listings occur at the end of each idea." and
   reads: *"Ideas will show footnotes everywhere their content appears: in
   their hatching context, their standalone page, and their `@idea:windows`."*
   True for an ordinary window, but not for a window carrying `limit:` under a
   paged target, where only the surviving footnotes are listed.

2. **The `limit` argument entry on `#window`.** Anchor:

   ```bash
   rg -n --fixed-strings 'How many blocks of the body to show' content/reference.typ
   ```

   TWO hits as of filing — line 628 and line 919. **You want line 919**, the
   `[`limit`]` row inside the `#window` argument table (landmark:
   `#reference(<window-reference>, ..)` above it). Line 628 is `#idea-body`'s
   own `limit` row and is NOT in scope; leave it alone. Tell them apart by the
   wording: the `#window` one reads "a block being a paragraph or a list, the
   unit that can be cut without leaving half a sentence", the `#idea-body` one
   reads "the same unit `#window`'s own `limit` cuts by".

## The steps

1. Correct the `content/concepts.typ` footnote so it no longer overclaims.
   Keep it one sentence in the same register — it is a parenthetical footnote,
   not a section. It should still say that an idea's footnotes travel with it
   to every surface, while noting that a window carrying `limit:` is the
   exception on a paged target, where only the footnotes whose marks survive
   the cut are listed.
2. Extend the `#window` `limit` entry at `content/reference.typ:919` with the
   footnote consequence: in HTML and EPUB the window lists every footnote in
   the note because the tail is only collapsed rather than dropped, and a
   footnote in the shown blocks appears twice as a result; under a paged target
   only the surviving ones are listed. Keep it to a clause or two — the
   argument table's other entries are one paragraph each and this one should
   not become an essay.
3. Read the `footnotes` concept in `content/concepts.typ` through afterwards
   (it starts at `#concept("footnotes"`) and confirm nothing else in it now
   reads as though footnote numbers could differ between surfaces.

## Non-goals

- Do not change what the site says about **idea-local numbering** — that two
  ideas on one page may each carry a footnote `1` is still exactly true, and
  `content/concepts.typ:106-107` says it correctly.
- Do not document `_number-footnotes`, the removed counter, the old `did not
  converge` warnings, or any other internal mechanism. Only what an author
  sees.
- Do not touch the `#footnote` reference note at
  `#reference(<footnote-reference>, ..)`. A separate bird covers the missing-
  import build error there, and editing it here would collide with that flight.
- Do not touch `content/reference.typ:628` (`#idea-body`'s `limit` row).
- Do not touch the `#window` reference note's backlink prose, its `backlink`
  row or its `filter` row — those were just corrected by a landed bird and are
  right.
- Do not add a new concept, a new reference note or a new argument row.
- Do not edit the sibling package repo `/home/lox/code/_fcl/rookery`.

## VERIFY

1. The overclaim is gone. This must print nothing:

   ```bash
   rg -n --fixed-strings 'in their hatching context, their standalone page, and their' content/concepts.typ
   ```

   (Assert on the replacement by reading it, not by a hit count — this site's
   prose is re-wrapped freely, so grep short fragments rather than sentences.)

2. The `limit` entry mentions footnotes. This must print at least one hit:

   ```bash
   rg -n -i 'footnote' content/reference.typ | rg -n '91[0-9]|92[0-9]'
   ```

   If the line numbers have moved, instead confirm by eye that the `[`limit`]`
   row in the `#window` argument table now mentions footnotes.

3. Quote both edited passages in your flight report so the claim can be
   checked against the readme without re-reading the site.

4. The site builds:

   ```bash
   cd /home/lox/code/_fcl/rookery.ohrg.org && just build
   ```

   which runs `rheo compile . --html` and then copies the fonts. Report the
   exit status. Note that `just build`'s `cp fonts/*.ttf` step fails inside a
   bd flight workspace, because `fonts/*.ttf` is gitignored and a flight has no
   `fonts/` directory — run `rheo compile . --html` there instead and report
   ITS exit status, which is the real check.