---
id: rkdoc-fix-the-page-slug-and-recursion-framing-9050461e
short-id: '9'
title: Fix the page slug and recursion framing
priority: 3
labels:
- fix-concepts-claims
deps: []
closed: true
---
Two claims on `content/concepts.typ` are wrong in ways a reader will act on:
one gives a URL shape that does not exist, and one misdescribes what the window
recursion budget is protecting against, in a way that would make a reader think
nested ideas are dangerous when they are not.

Touches: content/concepts.typ

## Problem one: the standalone page path

Anchor — one hit, in `content/concepts.typ` (line 167 as of filing), inside the
idea named `standalone-idea-pages`:

```
rg -n 'The slug for the standalone page will be' /home/lox/code/_fcl/rookery.ohrg.org/content
```

The sentence gives the path as `/ideas/<idea-name>`. Two things are wrong with
it as a literal instruction: the minted file is `ideas/<idea-name>.html`, with
the extension, and the path rheo emits is relative rather than rooted at `/`.

Confirm against this site's own build before rewriting — it mints its pages the
same way any rookery does:

```
cd /home/lox/code/_fcl/rookery.ohrg.org && just build >/dev/null && ls build/html/ideas | head
```

Rewrite the sentence to name `ideas/<idea-name>.html`. Mention that the
directory is configurable — it follows the `prefix` setting, and the
site-configuration table on `content/reference.typ` documents the argument that
moves it — rather than implying `ideas` is fixed.

## Problem two: what window recursion actually risks

Anchor — one hit, in `content/concepts.typ` (line 212 as of filing), the
opening sentence of the idea named `window-depth` ("Unfurling windows"):

```
rg -n 'can infinitely recurse' /home/lox/code/_fcl/rookery.ohrg.org/content
```

The sentence reads: "Windows on ideas that are _parents_ in the idea hierarchy
can infinitely recurse."

This conflates two unrelated things. **Nesting `#idea` inside `#idea` cannot
cycle** — an idea's body is finite and literally contains the ideas written
inside it, so a nested idea is always rebuilt in full whatever the unfurl budget
is. The package's own source says so explicitly, in `src/window.typ`'s comment
on what nesting counts.

What CAN cycle is a **window cycle**: an idea that windows onto itself, or two
ideas that window onto each other. That is what the unfurl budget makes safe to
compile, and it has nothing to do with parent-child nesting.

Rewrite the opening sentence to say that. The rest of the idea — the budget's
meaning, the default of `1`, the per-window and site-wide settings, the worked
self-window example at the end — is correct and stays. The self-window demo at
the bottom of that idea is in fact a perfect illustration of the real hazard, so
the corrected opening should set it up rather than contradict it.

While rewriting, note that the idea's own name is `window-depth` while the
configuration argument is `window-unfurl` and the page's prose says "unfurl"
throughout. Renaming the idea would break every `@idea:window-depth[..]`
reference on the site, so **leave the name alone** — just make sure the prose
consistently says unfurl.

## Non-goals

- Do NOT rename the `window-depth` idea or change any idea's name on this page.
  Names are the site's link targets; renaming one breaks inbound references and
  is not what this bird is for.
- Do NOT edit `content/reference.typ`. Separate birds own it.
- Do NOT rewrite the `auto-naming` idea on this page. It is correct.
- Do NOT restructure the page or move ideas between pages.

## VERIFY

1. `rg -n 'ideas/<idea-name>\.html' /home/lox/code/_fcl/rookery.ohrg.org/content/concepts.typ`
   prints one hit.
2. `rg -n 'in the idea hierarchy can infinitely recurse' /home/lox/code/_fcl/rookery.ohrg.org/content`
   prints nothing.
3. `rg -n 'window-depth' /home/lox/code/_fcl/rookery.ohrg.org/content` prints
   the same hits it did before — no reference was broken by a rename.
4. From the repository root, `just build` succeeds and prints a compilation
   summary. A broken `@idea:` reference fails the compile, so this is the real
   check on step 3.