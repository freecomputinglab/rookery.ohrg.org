---
id: rkdoc-migrate-the-site-to-core-s-current-api-5fc18186
short-id: '5'
title: Migrate the site to core's current API
priority: 3
labels:
- feat-core-api-migration
deps: []
closed: true
---
Touches: content/_lib/prelude.typ, content/index.typ, content/faq.typ, content/concepts.typ, content/reference.typ, content/packages/core.typ

`@rookery/core` is being reworked across a chain of birds in its own repo
(`/home/lox/code/_fcl/rookery`, package `core/0.1.0`): arguments renamed, a default flipped,
new arguments added, and a new front door onto an existing function. This site both CALLS that
API and DOCUMENTS it, so it goes stale in two ways at once — pages stop building, and pages that
do build teach the wrong thing.

**Read the package, not this bird, for what the new spellings are.** The core birds are being
worked as this one waits, and names may still move while they are. This description is
deliberately a map of what THIS REPO has to touch; the authority for every new spelling is
`@rookery/core` itself, at the ref this site resolves.

## Before doing anything: check the API is actually live

This project resolves the package from a git ref, not from a local checkout —
`rheo.toml` (as of filing, lines 29-31):

```toml
[packages.rookery]
repo = "https://github.com/freecomputinglab/rookery"
branch = "0.1.0"
```

So the migration is only safe once the core changes are ON that branch. Step one is therefore:

1. Read `@rookery/core`'s own readme at the resolved ref, starting with its **migration
   section** — it carries a row per rename, which is the fastest complete answer to "what is
   this called now". The local checkout of that repo is at
   `/home/lox/code/_fcl/rookery/core/0.1.0` (`readme.md` and `src/`), useful for reading even
   when the branch has not moved.
2. If the new API is NOT yet on that branch, STOP and report that. Do not migrate speculatively
   against names that may still change, and do not edit `rheo.toml` to point somewhere else.
3. If it is live, note which renames actually landed and which did not — then work only from
   that list. A rename named below that the package did not in fact make is a rename you must
   not apply.

## What this repo has to touch

Each block below is a place this site is coupled to core. Find them by anchor, then look up the
current spelling in the package.

4. **Legacy `show-*` arguments — these become hard errors.** They are inert TODAY: core's
   `#idea`/`#window` swallow unknown named arguments silently, so these have been doing nothing
   for a while. One of the core birds makes an unknown named argument panic, at which point
   every one of these fails the build.

   ```
   rg -n 'show-(tags|date|frame|id|label|background|title|context|backlinks)' content/
   ```

   Roughly seventeen hits as of filing, across `content/faq.typ` (lines 6, 8, 10),
   `content/concepts.typ` (1, 4, 6, 196, 198, 220, 230, 232, 233), `content/index.typ` (14, 22)
   and `content/reference.typ` (11, 12, 174). Some are live arguments, some are prose naming
   the argument — fix both. The current spelling of each is in core's readme.

5. **Every bare `#ideas-outline()` — the default flipped under it.**

   ```
   rg -n 'ideas-outline\(' content/
   ```

   Six hits as of filing: `content/reference.typ:14`, `content/concepts.typ:15`, `:262` and
   `:272`, `content/faq.typ:13`, `content/packages/core.typ:12`. A call that means "this page's
   ideas" today means the whole rookery after the change, and the argument that narrows it has
   been renamed. Decide per call site which scope the page actually wants — a page-level
   contents list at the top of a page almost certainly wants the narrow one — and spell it the
   way the package now spells it. `content/concepts.typ:288` passes the OLD narrowing argument
   explicitly and needs the new name.

6. **The transclusion budget, renamed.**

   ```
   rg -n 'window-depth|depth:' content/
   ```

   As of filing: `content/reference.typ` lines 63, 78, 100 and 102 (two live settings, plus a
   documented table row and its description), line 496 (prose describing the argument on
   `#window`), and line 595 (a live call). Note that `#ideas-outline`'s own depth argument is
   NOT renamed — check each hit for which function it belongs to before changing it.

7. **The registry accessors, renamed.**

   ```
   rg -n 'note-href|note-path|tags-of|tag-value' content/
   ```

   As of filing: `content/reference.typ` lines 570, 579 (a live `#import` naming several), 583,
   586, 621, 641 and 643 — the last two being reference entries whose TITLES are the function
   names (`#reference(<tags-of-reference>, title: [`#tags-of`])`). Renaming those titles changes
   the ideas' derived ids, so check whether anything links to them with `@idea:tags-of-reference`
   before deciding whether to rename the label as well as the title.

8. **Tag SELECTION versus tag ASSIGNMENT.** One of the core birds splits these into two
   different argument names. Assignment call sites stay as they are; selection call sites change.

   ```
   rg -n 'ideas\(tags:|#window\([^)]*tags:|ideas-outline\([^)]*tags:' content/
   ```

   As of filing: `content/reference.typ:581` (`ideas(tags: "concept")`, live) and `:480` (prose
   describing the argument). Read the package to confirm which name is which before touching a
   call that assigns.

9. **The two pages that DOCUMENT core's arguments.** These are the ones that go quietly wrong
   rather than failing:

   - `content/reference.typ` — a full API reference, including a `#window` argument table
     (around lines 470-530 as of filing) and a `#rookery` settings table (around lines 90-110).
   - `content/packages/core.typ` — the `<core-idea>`, `<core-ideate>` and `<core-window>` ideas,
     each with an argument table and a `display` dictionary code block. The `<core-idea>` block
     says the dictionary has "seven flags"; one of the core birds changes how many there are, so
     that count needs checking against the package rather than adjusting by guess.

   Walk both pages against the package's current signatures and correct every row. Where the
   package has GAINED an argument, add a row for it in the same register as its neighbours
   rather than leaving the table silently short.

10. **The prelude's import.** `content/_lib/prelude.typ` line 14 as of filing imports four names
    from core. If any of those four was renamed, this line breaks every page at once — check it
    first, since a mistake here is not subtle.

11. **New features worth documenting, not just renames.** The core chain adds arguments and at
    least one new function. Read the package's readme for what is NEW, and document each where
    this site already documents its neighbours — the reference page for the API surface, the
    concepts page where a feature needs explaining rather than listing. Do not invent coverage
    for something the package did not ship.

## Non-goals

- **Do not edit `/home/lox/code/_fcl/rookery`.** That repo has its own birds for the API work;
  this one is the site reacting to it.
- **Do not edit `rheo.toml`.** Not the repo, not the branch, not the version. If the site cannot
  resolve the new API, that is a fact to report, not to route around.
- **Do not run `build.sh`.** It is CI-only: it downloads a pinned release binary and clones and
  builds the packages. Local verification is `rheo compile .` or the repo's own `just build`.
- **Do not rewrite prose beyond the API facts.** Tables, argument names, counts and examples,
  yes; the pages' voice and structure, no.
- **Do not bulk find-and-replace.** Several of these names mean different things in different
  places — the same word is an argument on one function and a field or a different argument on
  another. Every hit gets read before it is changed.

## VERIFY

1. `just build` at the repo root succeeds (it runs `rheo compile . --html` and copies the
   fonts). If `rheo` is not on PATH, say so rather than skipping quietly.
2. `rg -n 'show-(tags|date|frame|id|label|background|title|context|backlinks)' content/` returns
   nothing.
3. Every grep in steps 5 through 8 returns either nothing or only hits you can name a reason
   for, and your report lists those reasons.
4. The built site has the pages the migration touched: `build/html/reference.html`,
   `build/html/concepts.html`, `build/html/faq.html`, `build/html/packages/core.html` all exist
   and are newer than the start of the flight.
5. Spot-check one migrated page's OUTPUT for a scope change rather than only for a clean build:
   the page-level contents list at the top of `build/html/concepts.html` must still list that
   page's own ideas, not every idea on the site.
6. `bd status <this bird's id>` reports `retired` after the flight lands.