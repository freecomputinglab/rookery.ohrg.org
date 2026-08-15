#import "template.typ": template
#import "@rheo/rookery:0.1.0": idea, note, todo, view

#show: template.with(current-page: "index")

// Every note inherits this date, so a view's summary carries a muted date —
// the only metadata a summary shows.
#set document(date: datetime(year: 2026, month: 8, day: 15))

#context if target() == "html" [
  - #link(<guide:intro>)[Transclusion and references]
  - #link(<about>)[About]
]

= Rookery under Rheo

Atomic, interlinked, transcludable notes for Typst, Zettelkasten-style. This
site is built with #link("https://rheo.ohrg.org/")[Rheo] and documents
`@rheo/rookery` by using it: every note below is a real `#idea`, and every
page under `notes/` was minted from one.

A note exists only where you write `#idea("name")[...]`. There is no document
show rule and no "every heading is a note" behaviour — a labelled heading is
just a labelled heading.

== The notes

#idea("rookery", title: [rookery])[
  Build a rookery plugin for Rheo that gives a Zettelkasten flavour.
]

#idea("tagged", labels: ("draft", "review"))[
  A note with multiple labels, to exercise the `labels` mechanism.
]

#idea[An auto-id note — read its generated id off the permalink beside it.]

#note("n1", title: [A note])[Sugar over `labels: ("note",)`.]

#todo("t1", labels: ("draft",))[Sugar over `labels: ("todo", "draft")`.]

#idea("multi", title: [Multi-block])[
  First paragraph of a multi-block note, for exercising `#view`'s `limit:`.

  Second paragraph, which `limit: 1` should truncate away.
]

== Views of them

Hover a summary and it tints; click it and it folds. Only the `[note:...]`
permalink leaves the page — see @guide:intro for the same views one directory
down, where every href has to come out a level deeper.

#view(("rookery", "tagged", "n1"), folded: true)

#view("multi", limit: 1)
