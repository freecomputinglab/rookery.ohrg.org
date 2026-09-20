---
id: rkdoc-document-the-missing-css-levers-893cba0b
short-id: '8'
title: Document the missing CSS levers
priority: 2
labels:
- document-css-levers
deps:
- blocked-by:rkdoc-fix-the-filter-cell-and-a-miscount-161ee471
closed: false
---
`content/reference.typ` carries two tables a reader consults when writing their
own stylesheet over the package's: an HTML class reference and a CSS variable
reference. Both are incomplete. Five CSS custom properties that `core.css`
reads specifically so a downstream stylesheet can set them are missing from the
variable table, and one emitted class is missing from the class table.

Touches: content/reference.typ

## The package's stylesheet

Everything below is verifiable in the package's own CSS, which is on this
machine at an absolute path:

```
/home/lox/code/_fcl/rookery/core/0.1.0/src/core.css
```

Read the comment above each property before documenting it — `core.css`
explains in place what each one is for, and those explanations are the source
for the table cells.

## The five missing CSS custom properties

Find them:

```
rg -n 'idea-heading-margin-top|idea-muted-color|idea-row-gutter|idea-row-pad-block|idea-row-rule-color' /home/lox/code/_fcl/rookery/core/0.1.0/src/core.css
```

Nine hits across five names as of filing. Each is a deliberate extension point:

| property | default | what it sets |
| --- | --- | --- |
| `--idea-heading-margin-top` | `0.75em` | The space above an idea's heading (`core.css` line 771). Its own comment invites a site to set this to return to its own vertical scale. |
| `--idea-muted-color` | `gray` | The colour of a de-emphasised row cell and of a "soft" row (lines 1262 and 1278). |
| `--idea-row-gutter` | `7.5em` | The width of a row grid's first column (line 1229). |
| `--idea-row-pad-block` | `0.45rem` | A row's vertical padding (line 1227). Published on purpose, and it inherits, so a cell can read it back. |
| `--idea-row-rule-color` | unset | The colour of a row's vertical rule (line 1352). `core.css` reads it and never sets it, precisely so a layered stylesheet can point it somewhere — a sibling package runs an urgency band down that bar. |

Confirm each default against the CSS rather than copying this table blind; the
numbers above are as of filing.

Add them to the existing CSS variable table. Anchor — one hit, in
`content/reference.typ` (line 302 as of filing), the idea named `css-reference`:

```
rg -n 'css-reference' /home/lox/code/_fcl/rookery.ohrg.org/content/reference.typ
```

The table there currently lists five properties (`--idea-tag-size`,
`--idea-tag-radius`, `--idea-tag-color` / `--idea-tag-bg`, `--idea-tag-line`,
`--idea-external-color`). Match their row format exactly.

**Do not add the ten theme properties** — `--idea-link-color`,
`--idea-fold-color`, `--idea-name-color`, `--idea-date-color`,
`--idea-border-color`, `--idea-rule-width`, `--idea-pad`, `--idea-label-font`,
`--idea-label-size`. Those are set through the `theme:` argument and are already
documented in the theme reference table on the same page. Adding them here would
duplicate that table and invite a reader to set them the wrong way.

## The missing class

Find it:

```
rg -n 'dup-warning' /home/lox/code/_fcl/rookery/core/0.1.0/src
```

Two hits, both in `src/validate.typ`, inside `_dup-warning-content`: the package
emits a `<p>` carrying the class `idea-dup-warning` and the attribute
`data-rookery="dup-warning"` when it detects two ideas claiming one name. It is
a real, styleable element and it appears nowhere in this site's class reference.

Add a row for it to that table. Anchor — one hit, in `content/reference.typ`
(line 225 as of filing), the idea named `class-reference`. Note that the class
STEM follows the `css-prefix` setting, exactly as every other row in that table
already explains, so document it the same way the neighbouring rows do rather
than hardcoding `idea-`.

## Non-goals

- Do NOT change the theme reference table. It is complete and correct — all ten
  keys check out against the package's theme module.
- Do NOT change any existing row in either table.
- Do NOT document internal CSS selectors, `@layer` names, or `data-rookery`
  attribute values beyond the one that comes with the new class row.
- Do NOT edit `core.css` or anything else under
  `/home/lox/code/_fcl/rookery/core/`. That is a different repository, pinned by
  remote ref, and nothing done here reaches it.
- Do NOT edit any other page under `content/`.

## VERIFY

1. `rg -n 'idea-heading-margin-top|idea-muted-color|idea-row-gutter|idea-row-pad-block|idea-row-rule-color' /home/lox/code/_fcl/rookery.ohrg.org/content/reference.typ`
   prints five or more hits.
2. `rg -n 'dup-warning' /home/lox/code/_fcl/rookery.ohrg.org/content/reference.typ`
   prints at least one hit.
3. `rg -n 'idea-link-color' /home/lox/code/_fcl/rookery.ohrg.org/content/reference.typ`
   prints no hit inside the `css-reference` table — the theme properties were
   not duplicated into it.
4. From the repository root, `just build` succeeds and prints a compilation
   summary.