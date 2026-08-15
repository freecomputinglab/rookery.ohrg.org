// A NESTED vertebra, deliberately: `guide:intro` is one level down, so every
// href rookery computes here has to come out as `../notes/<slug>.html` rather
// than `notes/<slug>.html`. That is what this page exercises.
#import "../template.typ": template
#import "@rheo/rookery:0.1.0": idea, view

#show: template.with(current-page: "guide:intro")

#set document(title: "Transclusion and references")

= Transclusion and references

Most of what follows refers to notes written on the #link(<index>)[home page].
Ids are flat, so a note is reachable from anywhere in the spine by name alone,
with no handle or filename prefix — and a note can be written anywhere too:

#idea("nested", title: [A note written here])[
  This one lives in `guide/intro.typ` rather than on the home page. Open its
  page from the permalink and the footer says so, linking back to this spot
  rather than to the top of the file. It also points at @note:rookery, so it
  appears in that note's backlinks — from a different page than the rest.
]

== References

`#show: template` applies rookery's `ref-rule`, so the terse `@note:rookery`
renders the note's title, linked, cross-page: @note:rookery.

Without that rule it would render as a bare figure number — a note's id lives
on a hidden anchor figure, and that is Typst's stock `@` rendering for one.

== Views

A transcluded view of the same note, cross-page:

#view("rookery")

A truncated view, `limit: 1`, dropping the second paragraph:

#view("multi", limit: 1)

Folded views are the same block, just closed. Click a summary to open it; only
the `[note:...]` permalink leaves the page. `limit:` still applies to what an
opened one reveals:

#view(("rookery", "tagged", "n1"), folded: true)

#view("multi", limit: 1, folded: true)
