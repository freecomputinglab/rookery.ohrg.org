#set document(
  title: "Rookery - Packages",
  date: datetime(year: 2026, month: 9, day: 19),
)

// THE SHELF THE PACKAGES SIT ON. Each package is written on its own page under
// `content/packages/`, and this one names them all as windows — each showing
// its package's name and the sentence that says what the package is for, so the
// set reads as an annotated list rather than a column of bare names.
//
// `@rookery/core` IS NOT ON THIS SHELF, and that is the point of the shelf:
// what sits here is what a rookery can be built WITH, on top of a core that
// every one of them already has. `#idea`, `#ideate` and `#window` are
// documented as the reference they are, under `@idea:api-surface` in
// `content/reference.typ`.
//
// Nothing is written here that is not written on a package's own page: a
// window transcludes its idea, it does not copy it, so this page cannot fall
// out of step with the pages it shows.
//
// `limit: 1` IS WHAT MAKES THIS AN OVERVIEW rather than eight whole pages
// inlined: it truncates each transcluded body to its FIRST BLOCK — one
// paragraph, everything above the first blank line — and marks the cut with a
// grey ellipsis. Every package page is written to suit, opening with a
// single-sentence statement of what the package does; a page that opens with
// something else will read badly here rather than break.
//
// THAT FIRST SENTENCE CANNOT CARRY AN APOSTROPHE, AN EM DASH OR AN `@idea:`
// REFERENCE, and the reason is not obvious: `limit:` counts blocks, and
// `_blocks` (`pure.typ`, `@rookery/core`) builds one by running together the
// children it recognises as inline — text, `raw`, `#link`, `#emph` and a dozen
// more. A `smartquote` (which is what `'` becomes), the element `---` resolves
// to, and a `ref` are on none of those lists, so each one ENDS the run: "the
// ideas of a rookery's own" is two blocks rather than one, and `limit: 1` shows
// everything up to the apostrophe and then the ellipsis. Hence "the ideas in a
// rookery" rather than "a rookery's ideas" on every page here, and commas where
// a dash would read better.
//
// The truncation is silent — the build succeeds and the shelf simply shows half
// a sentence — so anything written on a first line here is worth reading back
// out of `build/html/packages.html` once.
//
// NOT `folded: true`, which is what this page used to do. A folded window hides
// its body entirely behind the disclosure, summary line and all, so the reader
// has to click each of the eight to find out which one they want — exactly the
// thing the overview sentence exists to spare them. The permalink in each
// summary still goes to the package's own page, which is where the rest of it
// is.
//
// ONE CALL TAKING AN ARRAY, not one call per package — `#window` wants a
// single positional (`#window(("a", "b"))`, never `#window("a", "b")`) and
// refuses several, so the array form is the only way to name a set. Order is
// the call's, `sort` being left alone: `search` first, as the package a
// rookery of any size reaches for first.
#window(
  (
    <rookery-search>,
    <rookery-timeline>,
    <rookery-todos>,
    <rookery-cfps>,
    <rookery-bibtex>,
    <rookery-slipshow>,
    <rookery-pinboard>,
    <rookery-meetings>,
  ),
  limit: 1,
)
