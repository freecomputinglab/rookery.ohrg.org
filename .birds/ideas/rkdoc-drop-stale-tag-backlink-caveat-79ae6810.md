---
id: rkdoc-drop-stale-tag-backlink-caveat-79ae6810
short-id: '79'
title: Drop stale tag-backlink caveat
priority: 2
labels:
- fix-tag-window-backlinks
deps: []
closed: false
---
`content/packages/index.typ` builds the alpha-package shelf with
`#window(tagged: "alpha-package", limit: 1)`, and the comment above that call
records a limitation of `@rookery/core` which is being fixed upstream. When the
fix lands, the comment becomes false and has to go.

Touches: content/packages/index.typ

## What the comment says now

```
rg -n --fixed-strings 'do NOT show up in each package' /home/lox/code/_fcl/rookery.ohrg.org/content
```

One hit, `content/packages/index.typ` around line 28 as of filing, in the comment
block directly above the `#window(tagged: "alpha-package", limit: 1)` call (that
call is the landmark). The paragraph explains that these windows produce no
Backlinks entry on each package's minted page, because `#window` announces only
the ids it was NAMED and a tag scan needs a registry that the backlink walk is
still building.

That was true when written. It is the behaviour the upstream birds
`rk-backlink-tag-selected-windows-per-page-e99edead` and
`rk-backlink-tag-selected-windows-per-note-9f632f19` (in the sibling `rookery`
repo, label `fix-tag-window-backlinks`) remove: after them, a tag-selected window
DOES register a backlink, from the page it sits on and from the note it is
written inside. The one case that still registers nothing is a window that also
passes a `filter:` predicate, which this site does not use.

## Prerequisite — check before editing

This site pins `@rookery` to the `dev` branch (`rheo.toml`, `[packages.rookery]`),
so it picks the fix up as soon as it lands upstream. Confirm it actually has:

```bash
cd /home/lox/code/_fcl/rookery.ohrg.org && rheo compile .
grep -c -i backlink build/html/ideas/rookery-search.html
```

A positive number means the fix is in and this bird is workable. `0` means it has
not landed here yet — stop and report that rather than editing the comment to
describe behaviour the built site does not have.

## Steps

1. Delete the paragraph about backlinks from the comment above the `#window`
   call, and leave the rest of that comment alone — the paragraphs about the tag
   being the shelf, about `limit: 1` showing each stub's first block, and about
   tag selection sorting by id are all still true and still worth saying.

2. If the sentence about sort order shares a paragraph with the backlinks
   sentence, split them rather than deleting both.

## Non-goals

- Do NOT change the `#window` call itself, the tag, or `limit: 1`.
- Do NOT remove `tag: "alpha-package"` from any file under `content/packages/`.
- Do NOT touch `style.css` or `content/_lib/template.typ`.

## VERIFY

1. The stale claim is gone:

   ```bash
   rg -n --fixed-strings 'do NOT show up in each package' /home/lox/code/_fcl/rookery.ohrg.org/content
   ```

   Must print nothing.

2. The site still builds and the shelf still has all eight packages on it:

   ```bash
   cd /home/lox/code/_fcl/rookery.ohrg.org && rheo compile .
   rg -o 'idea:rookery-[a-z]+' build/html/packages.html | sort -u | wc -l
   ```

   Expect `8`.