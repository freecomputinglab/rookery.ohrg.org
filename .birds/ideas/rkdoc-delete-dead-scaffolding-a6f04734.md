---
id: rkdoc-delete-dead-scaffolding-a6f04734
short-id: a6
title: Delete dead scaffolding
priority: 2
labels:
- delete-dead-scaffolding
deps: []
closed: true
---
Two pieces of scaffolding sit in this repository that a reader would reasonably
assume are load-bearing, and neither is. This repository is about to be made
public as a reference example, so a file that exists only to be copied by
mistake is worth removing.

Touches: index.js, .gitignore

## Problem one: `index.js` is dead

```
cat /home/lox/code/_fcl/rookery.ohrg.org/index.js
```

Its entire contents are `console.log('Hello, Rheo.')` — project scaffolding from
`rheo init`. It is registered nowhere. Confirm:

```
rg -n 'index\.js' /home/lox/code/_fcl/rookery.ohrg.org --glob '!build/**' --glob '!.birds/**'
```

`rheo.toml` registers exactly two scripts, `nav.js` and `tables.js`, each under
its own `[[html.assets]]` table with a `js_scripts` key. `index.js` has no such
entry, appears in no built page, and is imported by nothing.

It sits at the repository root beside `nav.js` and `tables.js`, which is exactly
what makes it misleading: a reader copying this project's layout has no way to
tell the two registered scripts from the one that is not.

Delete it:

```
rm /home/lox/code/_fcl/rookery.ohrg.org/index.js
```

Before deleting, run the search above and confirm the only hits are the file
itself and anything under `build/` (which is generated and gitignored). If
anything in `content/`, `rheo.toml`, `style.css`, `nav.js`, `tables.js` or
`build.sh` references it, STOP and report that instead — the premise of this
step would be wrong.

## Problem two: two gitignore entries for tooling this project does not use

```
head -5 /home/lox/code/_fcl/rookery.ohrg.org/.gitignore
```

Lines 1 and 2 ignore `.beads/` and `.abacus/`. This project's tracker is birds
(`bd`), whose directory is `.birds/` and is committed on purpose. Confirm
neither directory exists and neither tool is referenced:

```
ls -a /home/lox/code/_fcl/rookery.ohrg.org | grep -E 'beads|abacus'
rg -n 'beads|abacus' /home/lox/code/_fcl/rookery.ohrg.org --glob '!.jj/**' --glob '!build/**'
```

Both should come back empty. If they do, delete the two lines. They are
copy-paste from a different project template and, in a repository held up as an
example, they suggest tooling that is not in play.

**Leave every other line of `.gitignore` alone** — `build/`, `.rheo-binary/` and
the `fonts/*.ttf` entry are all correct and load-bearing. The fonts entry in
particular is deliberate: Berkeley Mono is licensed, so its TTFs are not
committed.

## Non-goals

- Do NOT delete `nav.js` or `tables.js`. Both are registered in `rheo.toml` and
  both are referenced by the built pages.
- Do NOT add `index.js` to `rheo.toml` as an alternative to deleting it. There
  is nothing for it to do.
- Do NOT reorganize `.gitignore`, add entries, or reformat it.
- Do NOT touch `.birds/`.
- Do NOT edit `readme.md`. A separate bird rewrites it, and its layout table
  will be built from what is on disk after this bird lands.

## VERIFY

1. `ls /home/lox/code/_fcl/rookery.ohrg.org/index.js` reports the file does not
   exist.
2. `rg -n 'beads|abacus' /home/lox/code/_fcl/rookery.ohrg.org/.gitignore` prints
   nothing.
3. `rg -n 'fonts/\*\.ttf' /home/lox/code/_fcl/rookery.ohrg.org/.gitignore` prints
   one hit — the licensed-font entry survived.
4. From the repository root, `just build` succeeds and prints a compilation
   summary, and `just fonts` runs without error.