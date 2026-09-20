---
id: rkdoc-strip-the-stylesheet-s-banner-comments-093cfdeb
short-id: '0'
title: Strip the stylesheet's banner comments
priority: 1
labels:
- strip-css-banners
deps: []
closed: false
---
`style.css` is the file a reader of this repository is most likely to copy
wholesale — it is the one place the site layers its own styling over the
package's, and it explains that layering well. It also sets, throughout, the
exact comment convention this project's rules forbid: banner dividers marking
sections, and comments describing components that no longer exist.

Touches: style.css

## The rules being applied

From this project's `CLAUDE.md`:

- "**One header per file, no interior banners.** The first comment block says
  what the file is. A `// ---- Some Section ----` divider restating it is
  forbidden: the module is the section, and a file needing dividers is a file
  wanting to be two."
- "**Describe the present.** Say what the code is and why it is that way. Never
  what it used to be, what moved where, which release changed it, or that
  something 'is gone'."

## Problem one: seventeen banner dividers

```
rg -n '/\* =' /home/lox/code/_fcl/rookery.ohrg.org/style.css
```

Seventeen hits as of filing. Each is a `/* ===== SECTION NAME ===== */`-style
block marking a region of the stylesheet.

For each one:

- If the divider only names what the rules below it obviously are, delete it.
- If it carries a real explanation — several of these blocks do, and the
  explanation is the valuable part of this file — keep the explanation and drop
  the decorative `=====` framing, leaving an ordinary comment.

The file is long enough that losing all sense of structure would be a real cost.
Where a region genuinely needs marking, a plain one-line comment naming it does
the job without being a banner.

## Problem two: comments about components that are gone

```
rg -n 'unlike the old|no longer fits' /home/lox/code/_fcl/rookery.ohrg.org/style.css
```

Four hits as of filing (lines 329, 352, 782, 786):

- Line 329 — "not one wrapping the other, unlike the old `#search-bar`'s single
  `.rookery-search` span". `#search-bar` is a component shape that no longer
  exists. The present-tense claim (the two elements are siblings) is what
  matters; the comparison goes.
- Line 352 — "unlike the old dropdown's width cap below, which WAS measured
  against...". Same treatment: keep what is true of the rule it annotates.
- Lines 782 and 786 — two uses of "no longer fits" in a responsive breakpoint
  comment. This one is subtler: "below this width the nav no longer fits beside
  the wordmark" is describing what happens at a narrow viewport, not project
  history. Read each in context. If it is describing the layout at a width, it
  is present-tense and stays — reword only if it reads as a change over time.

## What must survive

This stylesheet's comments explain something a reader genuinely cannot work out
from the rules: how a site stylesheet layers over the package's own, including
the `@layer` cascade behaviour and the specificity consequences of the order
rheo links the two stylesheets in. **All of that stays.** It is the single most
useful thing in this repository for someone building their own rookery site, and
this bird must not thin it out.

If a judgement call is close, keep the comment.

## Non-goals

- Do NOT change any CSS rule, selector, property or value. This bird edits
  comments only. The site must render identically afterwards.
- Do NOT remove the explanations of the `@layer` cascade, the stylesheet
  ordering, or the doubled-selector specificity technique, wherever they appear.
- Do NOT touch `nav.js`, `tables.js`, or anything under `content/`.
- Do NOT reformat the stylesheet, reorder rules, or change indentation.

## VERIFY

1. `rg -n '/\* =' /home/lox/code/_fcl/rookery.ohrg.org/style.css` prints nothing.
2. `rg -n 'unlike the old' /home/lox/code/_fcl/rookery.ohrg.org/style.css` prints
   nothing.
3. `rg -n '@layer' /home/lox/code/_fcl/rookery.ohrg.org/style.css` prints the
   same hits it did before — no rule was touched.
4. `rg -c '^\s*\.' /home/lox/code/_fcl/rookery.ohrg.org/style.css` prints the
   same number as before the change — no selector was added or lost.
5. From the repository root, `just build` succeeds and prints a compilation
   summary.