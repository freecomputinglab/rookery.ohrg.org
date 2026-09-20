---
id: rkdoc-correct-the-auto-naming-reference-e4f7d239
short-id: e
title: Correct the auto-naming reference
priority: 3
labels:
- fix-auto-naming-reference
deps: []
closed: true
---
`content/reference.typ` describes how `@rookery/core` names an idea that was
given no name, and describes it wrongly — as an ordinal counter. The package
has not worked that way since unnamed naming became a pure function of an
idea's own content, and this site's own `content/concepts.typ` describes the
real algorithm correctly two pages away. The reference contradicts the concepts
page on the package's own central mechanism.

Touches: content/reference.typ

## What the code actually does

An idea with no explicit name gets its name in this order:

1. If it has a `title`, a kebab-case slug of that title.
2. If it has no usable title, a slug of its own BODY — whole words, capped at
   16 characters — with a three-character content digest appended, so two ideas
   opening the same way still land apart.

There is no counter and no ordinal anywhere in this path, and nothing about the
result depends on where the idea sits: a nested titleless idea derives its name
from its own body exactly as a top-level one does, and carries nothing of its
parent's name. That position-independence is the point of the scheme — it is
what lets an idea move between files without its name changing.

This site's `content/concepts.typ` already states this correctly, in the idea
named `auto-naming` ("How are ideas auto-named?"). Read it before writing the
replacement so the two pages agree:

```
rg -n 'auto-naming' /home/lox/code/_fcl/rookery.ohrg.org/content/concepts.typ
```

## Site one: the `#idea` argument table

Anchor — one hit, in `content/reference.typ` (line 419 as of filing), in the
`name` row of the argument table inside the idea named `idea-reference`:

```
rg -n 'takes an ordinal scoped to its enclosing' /home/lox/code/_fcl/rookery.ohrg.org/content
```

The cell ends: "In the absence of an explicit name, an idea with a `title` takes
a slug of it; an idea with no usable title instead takes an ordinal scoped to
its enclosing idea, or, at the top level, to the page."

The first half is right. Replace the second half with the body-slug-plus-digest
rule described above. Keep it to one sentence — this is a table cell, and
`concepts.typ` is where the fuller explanation lives. A cross-reference to it is
appropriate: the page already uses `@idea:auto-naming[..]` elsewhere.

## Site two: the `#ideate` argument table

Anchor — one hit, in `content/reference.typ` (line 780 as of filing), in the
`name` row of the argument table inside the idea named `ideate-reference`:

```
rg -n 'container-scoped ordinal' /home/lox/code/_fcl/rookery.ohrg.org/content
```

The cell says `name:` defaults to `auto`, "which slugs the heading the same way
an unnamed `#idea`'s title is slugged, falling back to a container-scoped
ordinal when the heading yields no usable slug."

Same correction: the fallback is `#idea`'s own naming, which for a section with
no usable heading slug means a slug of the section's body plus a content digest.
The simplest accurate phrasing points at `#idea` rather than restating the rule
a third time, since `#ideate` genuinely does delegate to it.

## Non-goals

- Do NOT edit `content/concepts.typ`. Its description is correct, and a separate
  bird handles its other problems.
- Do NOT restructure the argument tables, add rows, or change any other cell.
- Do NOT write a new section about naming. The `auto-naming` idea on
  `concepts.typ` already is that section; these two cells should point at it,
  not compete with it.
- Do NOT change the `#ideate` `name:` cell's last sentence ("A fixed value is
  refused, as it would mint every idea in the body under one name"). It is
  correct.

## VERIFY

1. `rg -n 'ordinal' /home/lox/code/_fcl/rookery.ohrg.org/content/reference.typ`
   prints nothing.
2. `rg -n 'digest' /home/lox/code/_fcl/rookery.ohrg.org/content/reference.typ`
   prints at least one hit.
3. From the repository root, `just build` succeeds and prints a compilation
   summary — the page still compiles.