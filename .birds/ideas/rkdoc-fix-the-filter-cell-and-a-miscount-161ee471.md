---
id: rkdoc-fix-the-filter-cell-and-a-miscount-161ee471
short-id: '1'
title: Fix the filter cell and a miscount
priority: 2
labels:
- fix-reference-smalls
deps:
- blocked-by:rkdoc-correct-the-auto-naming-reference-e4f7d239
closed: true
---
Two small errors in `content/reference.typ`: a table cell overstates what
`filter:` does to backlinks, contradicting the fuller explanation a few
paragraphs below it on the same page, and a sentence promises two items and
then lists four.

Touches: content/reference.typ

## Problem one: the `filter:` backlink claim

Anchor — one hit, in `content/reference.typ` (line 907 as of filing), the
`filter` row of the `#window` argument table inside the idea named
`window-reference`:

```
rg -n 'passing it also means no backlinks are registered' /home/lox/code/_fcl/rookery.ohrg.org/content
```

The cell ends: "On `#window`, passing it also means no backlinks are
registered."

That is too broad. What the package actually does: the ideas a window pulls in
**via the tag/filter selection path** do not register backlinks, but ideas
**named outright in the same call** still do. So `#window("etal", filter: f)`
registers a backlink for `etal` exactly as it would without the filter — the
named ids ride along independently of the filtered selection.

The longer prose further down the same idea already states this correctly ("the
one selection that registers nothing is `filter`", in the passage the cell
points at with "for the reason given below"). Read that passage and make the
cell agree with it:

```
rg -n 'the one selection that registers nothing' /home/lox/code/_fcl/rookery.ohrg.org/content/reference.typ
```

Rewrite the cell's last sentence so it says the filtered selection registers no
backlinks, leaving the "for the reason given below" pointer intact.

## Problem two: an off-by-two count

Anchor — one hit, in `content/reference.typ` (line 405 as of filing), in the
prose introducing the API surface listing, inside the idea named `api-surface`:

```
rg -n 'Two names are left off the list' /home/lox/code/_fcl/rookery.ohrg.org/content
```

The sentence reads "Two names are left off the list", then names four
identifiers: `#rookery`, and the three marker constants `IK`, `WK` and `FNK`.

The intent is two KINDS of thing — the show rule, and the marker constants — so
the fix is a wording change, not a renumber. Something like "Two kinds of name
are left off the list" reads correctly with the rest of the sentence unchanged.
Confirm the count by reading the sentence in full before editing; do not simply
change "Two" to "Four", which would misdescribe the structure of the sentence
that follows.

## Non-goals

- Do NOT change the longer `filter:` passage further down the page. It is
  correct and is what the table cell is being made to agree with.
- Do NOT add, remove, or reorder rows in the `#window` argument table.
- Do NOT change which symbols are documented on the API surface listing. The
  listing is complete; only the sentence introducing the exclusions is wrong.
- Do NOT edit any other page under `content/`.

## VERIFY

1. `rg -n 'Two names are left off' /home/lox/code/_fcl/rookery.ohrg.org/content`
   prints nothing.
2. `rg -n 'IK' /home/lox/code/_fcl/rookery.ohrg.org/content/reference.typ` still
   prints at least one hit — the marker constants are still mentioned.
3. `rg -n 'for the reason given below' /home/lox/code/_fcl/rookery.ohrg.org/content/reference.typ`
   prints one hit — the pointer into the longer passage survived.
4. From the repository root, `just build` succeeds and prints a compilation
   summary.