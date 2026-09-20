---
id: rkdoc-correct-the-tagged-window-backlink-rule-b1ab3ada
short-id: b1
title: Correct the tagged-window backlink rule
priority: 3
labels:
- fix-tag-window-backlinks
deps: []
closed: false
---
`content/reference.typ` tells readers flatly that a tag-selected `#window`
never gives the idea it shows a backlink. `@rookery/core` no longer behaves
that way: a tag-selected window now registers a backlink from the page it sits
on AND from the idea whose body it is written in. The paragraph saying
otherwise has to go, and the two argument entries around it have to gain the
rule that replaces it.

Touches: content/reference.typ

## What core does now

Verify it before editing, against the package's own source in the sibling repo
`/home/lox/code/_fcl/rookery` — this site pins `@rookery` to the `dev` branch,
and rheo caches git refs under `~/.cache/rheo/git`, so a local build can
quietly keep using an older `dev` than the source you are reading:

```bash
rg -n '_outbound-tag-selectors' /home/lox/code/_fcl/rookery/core/0.1.0/src/links.typ
rg -n 'filtered' /home/lox/code/_fcl/rookery/core/0.1.0/src/window.typ
```

Both should print hits. If either prints nothing, the upstream change is not on
that branch yet — **stop and report that** rather than documenting behaviour
the package does not have.

The four rules, as core's own readme now states them:

1. A window that NAMES an idea links to it, exactly as it always did.
2. A window that selects by `tagged:` links to every idea the selection
   matches — both from the page the window sits on, and from the idea whose
   body the window is written in.
3. A window that passes `filter:` — alone, or together with `tagged:` —
   registers no backlinks at all. A filter is a Typst function and cannot ride
   in the metadata the backlink walk reads; since `filter:` is ANDed with
   `tagged:`, resolving the tag half alone would invent backlinks for ideas the
   filter excludes.
4. `backlink: false` suppresses all of it, unchanged.

A fifth fact, already true and not part of this change, is worth not
contradicting: an idea's own origin page never appears in its Backlinks,
because the Context listing already names it.

## The sites

Three, all in `content/reference.typ`, all inside the `#window` reference note
(`#reference(<window-reference>, ..)` is the landmark). Each anchor printed
exactly one hit when this was filed:

1. **The false paragraph.** Anchor:

   ```bash
   rg -n --fixed-strings 'One asymmetry is worth carrying' /home/lox/code/_fcl/rookery.ohrg.org/content
   ```

   One hit, `content/reference.typ:971` as of filing. The paragraph runs three
   lines and reads: *"One asymmetry is worth carrying: only a _named_ idea
   takes a backlink from the window showing it. A tag selection is not known
   until the registry can be read, and the backlink graph is built before that,
   so an idea pulled in by `tags` lists the windowing page nowhere."* It is the
   last thing in that note, immediately after the paragraph beginning "Each key
   is also an argument in its own right".

2. **The `backlink` argument entry.** Anchor:

   ```bash
   rg -n --fixed-strings 'Whether the window counts as a link from the page it sits on' /home/lox/code/_fcl/rookery.ohrg.org/content
   ```

   One hit, `content/reference.typ:935` as of filing — the description cell of
   the `[`backlink`]` row in the argument table. True as far as it goes, and
   now incomplete.

3. **The `filter` argument entry.** Anchor:

   ```bash
   rg -n --fixed-strings 'rather than replacing them' /home/lox/code/_fcl/rookery.ohrg.org/content
   ```

   One hit, `content/reference.typ:907` as of filing — the description cell of
   the `[`filter`]` row in the same table.

Line numbers are as of filing and will drift; resolve by running each anchor.
Anchor 1 is on the text being deleted, so it stops matching once step 1 lands
and must not appear in VERIFY. If an anchor prints nothing, widen the search to
the repo root; if it is still gone, report that rather than guessing.

## The steps

1. Replace the "One asymmetry is worth carrying" paragraph with the rule that
   is actually true. It should say that a tag-selected window DOES give every
   idea it matches a backlink, from the page it sits on and from the idea whose
   prose it is written in, and that the one selection which registers nothing is
   a window passing `filter:`, because a predicate cannot ride in metadata and
   is ANDed with `tagged:`. Keep it to the length of the paragraph it replaces —
   this is a reference page, and the argument table carries the per-argument
   detail.
2. Extend the `backlink` entry's description with the tag rule: `true` (the
   default) means the window links to every idea it shows, named or tagged.
   Leave the existing sentences about when to pass `false` exactly as they are —
   they are still right.
3. Extend the `filter` entry's description with one clause noting that a window
   passing `filter:` registers no backlinks, and why. Do not restate the whole
   rule there; point at it.
4. Read the whole `#window` reference note through afterwards and check nothing
   else in it still implies the old behaviour.

## Non-goals

- Do not touch `content/packages/index.typ`. The stale comment above its
  `#window(tagged: "alpha-package", limit: 1)` call is bird
  `rkdoc-drop-stale-tag-backlink-caveat-79ae6810`'s, and editing it here would
  collide with that flight.
- Do not touch anything either rename bird owns —
  `rkdoc-update-reference-for-the-name-renames-3a0d0b50` is rewriting the code
  samples, argument names and theme keys in this same file, including the
  `display: (id: true)` sample a few lines above site 1. Change prose about
  backlinks only, and leave every identifier spelled as you found it.
- Do not add a new section, a new reference note, or a new argument row.
- Do not document the origin-page exclusion as though it were new; it is not
  part of this change.
- Do not touch `content/concepts.typ`, `content/faq.typ`, `content/index.typ`
  or any page under `content/packages/`. They were swept and say nothing this
  change falsifies.
- Do not edit the sibling package repo `/home/lox/code/_fcl/rookery`.

## VERIFY

1. The false claim is gone. This must print nothing:

   ```bash
   rg -n -i 'lists the windowing page nowhere|only a _named_ idea takes a backlink' /home/lox/code/_fcl/rookery.ohrg.org/content
   ```

2. The replacement says what it should. Read the paragraph that now ends the
   `#window` reference note and confirm it states both halves — that a tagged
   window backlinks its matches, and that a filtered one backlinks nothing.
   Quote it in your flight report.

3. The two argument entries mention backlinks. This must print at least one hit
   for each of `backlink` and `filter`:

   ```bash
   rg -n -i 'backlink' /home/lox/code/_fcl/rookery.ohrg.org/content/reference.typ
   ```

4. The site still builds:

   ```bash
   cd /home/lox/code/_fcl/rookery.ohrg.org && just build
   ```

   which runs `rheo compile . --html` and then copies the fonts. Report the
   exit status.

Assert on the new wording rather than on a hit count, and grep short fragments
rather than whole sentences — this page's prose is re-wrapped freely, and a
sentence you match today may be split across two lines tomorrow.