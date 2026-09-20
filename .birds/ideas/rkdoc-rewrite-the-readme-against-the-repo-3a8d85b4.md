---
id: rkdoc-rewrite-the-readme-against-the-repo-3a8d85b4
short-id: 3a8
title: Rewrite the readme against the repo
priority: 4
labels:
- rewrite-site-readme
deps:
- blocked-by:rkdoc-delete-dead-scaffolding-a6f04734
closed: true
---
This repository is about to be made public and pointed to as the reference
example of how to build a real writing project with `@rookery/core` and Rheo.
Its `readme.md` is the first thing a visitor reads, and essentially every
specific claim in it is wrong: the package link points at a repository that is
not this package's, it documents two `just` recipes that do not exist, it names
a file at a path it does not occupy, it cites version numbers that exist
nowhere, and it describes a local development setup that is not how this site
resolves the package.

Rewrite it against what the repository actually is.

Touches: readme.md

## Each wrong claim, with the truth beside it

Run this to see them all at once:

```
rg -n 'lachlankermode|check-deps|bump-deps|content/template.typ|since 0\.4\.0' /home/lox/code/_fcl/rookery.ohrg.org/readme.md
```

Five hits as of filing (lines 3, 11, 17, 24, 35).

1. **The package repository link** (line 3) points at
   `https://github.com/lachlankermode/rheo-packages`. Neither the owner nor the
   repository name is right. The package lives at
   `https://github.com/freecomputinglab/rookery` — which is what this repo's own
   `rheo.toml` pins, under a `[packages.rookery]` table. Check it yourself:

   ```
   rg -n 'repo = ' /home/lox/code/_fcl/rookery.ohrg.org/rheo.toml
   ```

2. **`just check-deps` and `just bump-deps`** (lines 11 and 17) do not exist.
   Read the Justfile and document what is actually there:

   ```
   cat /home/lox/code/_fcl/rookery.ohrg.org/Justfile
   ```

   It defines `default`, `watch`, `build` and `fonts`. Delete both invented
   recipes and the sentence about moving version specs in one pass.

3. **`content/template.typ`** (line 24, in the layout table) is at
   `content/_lib/template.typ`. The readme's own later paragraph already says
   so, which makes the file self-contradicting.

4. **"on by default since 0.4.0"** (line 35). Every package in the family is at
   version `0.1.0` and always has been publicly; there is no 0.4.0. The claim
   that `ideas/index.html` is minted by default is TRUE — keep it, drop the
   version clause. This project's comment rules exclude version-since framing
   anyway.

5. **The local-development paragraph** (lines 14-16) says "on this machine the
   whole `rheo-packages` repo is symlinked in as the `rheo` namespace, so edits
   to the package land here on the next rebuild with no publish step."

   **This is not how this site resolves the package, and the difference
   matters.** `rheo.toml`'s `[packages.rookery]` table names a remote repository
   and a branch, and a build log confirms it: rheo reports resolving `@rookery`
   from that remote at a specific commit. A local edit to the package does NOT
   reach this site. Verify before writing the replacement:

   ```
   cd /home/lox/code/_fcl/rookery.ohrg.org && rheo compile . --html 2>&1 | grep '@rookery resolves'
   ```

   Replace the paragraph with what is true: the package is pinned by remote ref
   in `rheo.toml`, so the site builds the same way for anyone who clones it, and
   a change to the package reaches the site when that ref moves. If it is worth
   telling a reader how to point the pin at a local checkout instead, say so as
   an explicit alternative — a `repo = ` naming a filesystem path, which is what
   the sibling project at `/home/lox/code/waterline/rookery` does — and not as a
   description of the default.

## The layout table is missing most of the repository

The table lists eight paths. It omits `content/_lib/` (whose `prelude.typ` is
what applies the template to every page, per `rheo.toml`'s `[spine] prelude`),
the whole `content/packages/` directory (nine pages and a top-level nav
section), `index.js`, `nav.js`, `tables.js`, `build.sh`, `netlify.toml`,
`Justfile` and `rheo.toml` itself. Rebuild it from what is on disk:

```
cd /home/lox/code/_fcl/rookery.ohrg.org && ls -A && find content -type f | sort
```

One caveat: a separate bird deletes `index.js`, which is unused scaffolding.
Check whether it is still there before giving it a row.

## What a public exemplar's readme needs that this one lacks

The readme currently has no path from "I cloned this" to "I am looking at the
site". Add it, briefly:

1. **Getting Rheo.** The readme names no install step at all. Point at
   `https://rheo.ohrg.org/getting-started` rather than duplicating instructions
   that will drift.
2. **Running it.** `just watch` to live-rebuild and open, `just build` for a
   one-shot into `build/html/`. Both work on a fresh clone with no further
   setup — there is nothing to install into the Typst package cache, because the
   package is pinned by remote ref.
3. **The fonts.** Berkeley Mono is licensed, so its TTFs are gitignored and a
   fresh clone does not have them. The site builds and renders correctly
   without them, in the generic `monospace` fallback — the wordmark, the nav and
   an idea's name are what change. `just fonts` copies them into the build when
   they are present and prints a message when they are not; CI fetches them
   first, in `build.sh`. **Say this in the readme**, because right now it is
   explained only in `build.sh`'s comments, which a reader following the readme
   never opens.
4. **What to copy.** One short paragraph naming the two or three patterns this
   site is worth reading for — the `[spine] prelude` that applies the template
   once instead of per page, the `_lib/` exclusion that makes a library file
   not a page, and the way `style.css` layers over the package's own CSS.

## Also worth checking while in here

The readme's closing paragraph says this site "started as the `demo/rheo/`
directory inside the package repo and was moved out once it outgrew being a
test fixture". That is history, which this project's own rules exclude. Drop it.

Three different owner names appear across the repository — the readme's
`lachlankermode`, `rheo.toml`'s `freecomputinglab`, and the remote this
repository itself is pushed to. Step 1 fixes the readme's. Normalizing the
others is not this bird's business, but note it in the flight report.

## Non-goals

- Do NOT edit the `Justfile`. It is already correct — `build` and `watch` do not
  depend on `fonts`, and `fonts` guards for the TTFs being absent. The readme
  must describe it, not change it.
- Do NOT edit `build.sh`, `netlify.toml` or `rheo.toml`.
- Do NOT edit anything under `content/`. The site's own prose has separate
  birds.
- Do NOT delete `index.js` — a separate bird owns that.
- Do NOT write installation instructions for Rheo itself. Link to its docs.

## VERIFY

1. `rg -n 'lachlankermode|rheo-packages|check-deps|bump-deps|0\.4\.0|0\.5\.0' /home/lox/code/_fcl/rookery.ohrg.org/readme.md`
   prints nothing.
2. `rg -n 'content/_lib/template.typ' /home/lox/code/_fcl/rookery.ohrg.org/readme.md`
   prints at least one hit.
3. `rg -n 'freecomputinglab/rookery' /home/lox/code/_fcl/rookery.ohrg.org/readme.md`
   prints at least one hit.
4. `rg -n 'monospace' /home/lox/code/_fcl/rookery.ohrg.org/readme.md` prints at
   least one hit — the fonts fallback is explained.
5. Every `just` recipe named in the readme appears in the Justfile. Check by eye
   against `cat Justfile`; there are only four.
6. From the repository root, `just build` succeeds and prints a compilation
   summary — confirming the readme's own instructions work on this tree.