---
id: rkdoc-pin-the-genealogy-note-to-stop-d1a0cb07
short-id: d
title: Pin the genealogy note to stop convergence failure
priority: 4
labels:
- fix-idea-auto-id-drift
deps: []
closed: true
---
Touches: content/faq.typ

## The symptom

`rheo compile .` at the repo root emits five Typst warnings per output target,
headed:

```
warning: document did not converge within five attempts
warning: query for elements matching `selector.or(figure.where(kind: "rheo-idea"), <rookery-edge>)` did not stabilize
warning: value of `state("rheo-handle")` did not converge
warning: value of `state("rheo-handle")` did not converge
warning: value of `state("rheo-ideas-taken")` did not converge
```

and the build ships two dead permalinks — `build/html/ideas/what-is-the-genealogy-of-idea-1.html`
and `-2.html` are linked from other minted pages but never written.

## The cause

`@rookery/core` mints an unnamed note's id inside a `context` block, so the id
depends on where the note is standing rather than on the note itself. Any
re-render of a stored body — a `#window`, a minted page — mints a different id.
The phantom ids accumulate differently on each Typst layout run, which changes
how many pages `.marrow.typ` mints, which moves every element, and the document
never settles.

This site has exactly one note that takes that path: an `#idea` with a `title:`
and no pinned name.

```
rg -n 'What is the genealogy' /home/lox/code/_fcl/rookery.ohrg.org/content
```

One hit, `content/faq.typ` line 32 as of filing, nested inside the
`#faq(<inspiration>, ...)` note that opens at line 15:

```typ
  #faq(title: [What is the genealogy of `idea`?])[
```

MEASURED: pinning that one note clears all five warnings and both dead links.
The underlying package defect is being fixed separately in the `rookery` repo
(`/home/lox/code/_fcl/rookery`), which has its own tracker; this issue is the
site's own remedy and does not wait on it.

## Steps

1. Give that note a pinned name. Change the line above to:

   ```typ
   #faq(<genealogy>, title: [What is the genealogy of `idea`?])[
   ```

   `<genealogy>` is free: `rg -n 'genealogy' content/` returns only this one
   line, so nothing references the old derived id `idea:what-is-the-genealogy-of-idea`
   and no in-repo reference breaks.

2. Leave the note's body, title and tags alone. `#faq` is the site's own wrapper
   around `#idea` (defined at the top of `content/faq.typ`) and forwards `..args`,
   so a leading label argument reaches `#idea` unchanged.

## NON-GOALS

- Do not pin `content/concepts.typ`'s `#idea[Hatch a new idea.]` or
  `content/reference.typ`'s `#idea[I want to hatch ideas with rookery.]`. Both
  sit inside ```typ code fences and are never compiled.
- Do not touch `@rookery/core` or anything under `~/.cache/typst/packages/`.
  The package fix is tracked in the `rookery` repo.
- Do not rewrite the FAQ's prose, reorder its notes, or change the site's
  documentation of how ids are minted — that is a separate issue here.

## VERIFY

1. From the repo root, `rheo compile .` must report no convergence warning on
   any target:

   ```
   rheo compile . 2>&1 | grep -c 'did not converge\|did not stabilize'
   ```

   Expected output: `0`.

2. Every minted-page href must resolve to a file that exists:

   ```
   rheo compile . >/dev/null 2>&1
   grep -rhoE 'href="\.\./ideas/[a-z0-9-]+\.html"' build/html/ideas/*.html \
     | sed 's/.*ideas\///; s/"//' | sort -u > /tmp/want.txt
   ls build/html/ideas > /tmp/have.txt
   comm -23 /tmp/want.txt /tmp/have.txt
   ```

   Expected output: nothing.

3. The note's page is minted under its new id:

   ```
   ls build/html/ideas/genealogy.html
   ```

   Expected: the file exists.