---
id: rkdoc-update-reference-for-the-name-renames-3a0d0b50
short-id: '3'
title: Update reference for the name renames
priority: 2
labels:
- fix-idea-name-terminology
deps: []
closed: false
---
Touches: content/reference.typ, style.css

## Why

This site documents `@rookery/core`'s author-facing surface. That package is
standardising on one word for the thing that names a note — **name** — and is
renaming the last identifiers that said *id* instead.

The site's prose has already been converted: `content/concepts.typ`,
`content/index.typ`, `content/faq.typ`, `content/packages/search.typ`,
`readme.md` and the descriptive columns of `content/reference.typ` all say
*name* now. What is left is the **code** the reference page quotes — argument
names, theme keys, CSS custom properties and code samples — which still shows
the old spellings because the package still exports them.

**This bird WAITS on the package.** The renames happen in
`/home/lox/code/_fcl/rookery` (its own tracker, label
`fix-idea-name-terminology`). Do not start until they have landed. Check with:

```
rg -n 'ideate-name' /home/lox/code/_fcl/rookery/core/0.1.0/src/pure.typ
rg -n 'display-name' /home/lox/code/_fcl/rookery/core/0.1.0/src/idea.typ
rg -n 'name-color.*--idea-name-color' /home/lox/code/_fcl/rookery/core/0.1.0/src/theme.typ
```

If any of the three prints nothing, that rename has not landed. **Stop and
report which ones are missing** rather than documenting a surface that does
not exist — a reference page describing `#ideate-name` while the package still
exports `#ideate-id` is worse than one that is merely behind.

If only some landed, do only the steps for those and say so in the flight
report. The steps below are independent of one another.

## The three renames, as the package makes them

1. `#ideate-id(id)` becomes `#ideate-name(name)`.
2. `display-id:` becomes `display-name:`, and the `display` dictionary's `id`
   key becomes `name`.
3. The theme key `id-color` becomes `name-color`, and the CSS custom property
   `--idea-id-color` becomes `--idea-name-color`. `search`'s own
   `--rookery-search-id-color` becomes `--rookery-search-name-color`.

Nothing else is renamed. In particular the `.id` field on `ideas()` rows and
the `id:` parameter of `idea-page-template` keep their names, because `ideas()`
rows already carry a distinct `name` field holding the prefix-stripped form —
so `.id` cannot become `.name` without a collision. Leave both alone.

## Steps

1. Rename `#ideate-id` in the reference page. Anchor:

   ```
   rg -n 'ideate-id' /home/lox/code/_fcl/rookery.ohrg.org/content
   ```

   Two hits as of filing, both in `content/reference.typ` inside the
   `<ideate-id-reference>` block — line 857, the `#reference(..)` call itself
   (``#reference(<ideate-id-reference>, title: [`#ideate-id`])[``), and line
   863, the code sample `#ideate-id("the-name-i-want")`.

   Rename the displayed function name in the `title:` and the call in the
   sample. **Also rename the Typst label** `<ideate-id-reference>` to
   `<ideate-name-reference>`, and then fix every reference to it:

   ```
   rg -n 'ideate-id-reference' /home/lox/code/_fcl/rookery.ohrg.org/content
   ```

   A rookery name is a Typst label, so a dangling `@idea:ideate-id-reference`
   is a compile error — the build in VERIFY catches it.

2. Rename the `display` dictionary key in the three code samples that set it.
   Anchor:

   ```
   rg -n '^        id: (true|false),' /home/lox/code/_fcl/rookery.ohrg.org/content/reference.typ
   ```

   Three hits as of filing — lines 477 (`id: true,`, with the comment above it
   reading `// the name is shown in the hat as a permalink`), 815
   (`id: false,`) and 975 (`id: true,`, comment `// the name is shown in the
   summary as a permalink`). Each is a key inside a `display: (..)` dictionary
   in a sample; rename the key to `name`.

   Then check whether the page names the nine display keys anywhere as a list
   or table, and rename `id` to `name` there too:

   ```
   rg -n 'display' /home/lox/code/_fcl/rookery.ohrg.org/content/reference.typ | rg -n 'nine|backlinks.*context|flags'
   ```

   Read the hits; the `#idea` section describes the dictionary as "nine flags"
   and the `#rookery` configuration table refers to it. If a key list is
   spelled out, `id` in it becomes `name`.

3. Rename the theme key and the custom property in the reference tables.
   Anchors:

   ```
   rg -n 'id-color' /home/lox/code/_fcl/rookery.ohrg.org/content/reference.typ
   ```

   Three hits as of filing — line 199, the theme table row
   ``[`id-color`], [`gray`], [The `[idea:etal]` name's own text.],``, and
   lines 320 and 328, both `` [`--idea-id-color`, ...] `` rows in the HTML
   custom-property table. Rename the key to `name-color` and the property to
   `--idea-name-color`.

   Keep each table in whatever order it currently uses — if the rows are
   alphabetical, move the renamed row to where it now sorts.

4. Rename the site's own stylesheet override. Anchor:

   ```
   rg -n 'rookery-search-id-color' /home/lox/code/_fcl/rookery.ohrg.org/style.css
   ```

   One hit, line 338 as of filing:
   `--rookery-search-id-color: var(--muted);`. Rename it to
   `--rookery-search-name-color`.

   This one fails **silently** if missed — a CSS custom property nobody reads
   is not an error, the rule simply stops applying and the search rows lose
   their muted colour. So do not rely on the build to catch it; VERIFY checks
   it directly.

## NON-GOALS

- **Do not rename `.id` or `idea-page-template(id: ..)`.** The `ideas()` row
  table's `id` / `name` rows on this page are already correct: `id` is the full
  prefixed form, `name` the bare one. `content/_lib/template.typ` declares
  `#let idea-page(id: none, note: (:), doc)` because the package calls it with
  that parameter name — renaming it breaks the site's minted pages.
- **Do not touch the `idea:` prefix**, `@idea:` references, the `.idea-box` /
  `.idea-head` / `.idea-tab` CSS classes, or any other `idea-`/`--idea-` name
  that is not `--idea-id-color`. `idea` is the note itself, which is not what
  is being renamed.
- **Do not reword the site's prose.** The prose pass is already done; this bird
  is only the code the reference page quotes.
- **Do not add a page, a note, or a section**, and do not re-pin or rename any
  of the site's own notes.
- **Do not edit anything under `/home/lox/code/_fcl/rookery`** or under
  `~/.cache/typst/packages/`.

## VERIFY

1. No old spelling survives in the site's own sources. This must print
   nothing:

   ```
   rg -n 'ideate-id|idea-id-color|rookery-search-id-color' /home/lox/code/_fcl/rookery.ohrg.org/content /home/lox/code/_fcl/rookery.ohrg.org/style.css
   ```

   If a rename was skipped because the package had not landed it, say which,
   and expect exactly that spelling to survive.

2. The site builds clean from the repo root — this is also what catches a
   dangling label from step 1:

   ```
   rheo compile . 2>&1 | tail -20
   ```

   It must end in `compilation complete` and report no error. Note that
   `build.sh` is CI-only (it downloads a pinned release binary and clones the
   `@rheo` packages); do not run it.

3. No convergence warning. This must print `0`:

   ```
   rheo compile . 2>&1 | grep -c 'did not converge\|did not stabilize'
   ```

4. The new names are present where they belong. Each must print at least one
   hit:

   ```
   rg -n 'ideate-name' /home/lox/code/_fcl/rookery.ohrg.org/content/reference.typ
   rg -n 'name-color' /home/lox/code/_fcl/rookery.ohrg.org/content/reference.typ
   rg -n 'rookery-search-name-color' /home/lox/code/_fcl/rookery.ohrg.org/style.css
   ```

5. Open `build/html/reference.html` and read the `#ideate-name` section and
   the theme table. The function name in the heading and the one in the code
   sample below it must agree.