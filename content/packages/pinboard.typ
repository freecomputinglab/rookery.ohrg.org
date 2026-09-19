#set document(
  title: "Rookery - @rookery/pinboard",
  date: datetime(year: 2026, month: 9, day: 19),
)

// THE FIRST BLOCK IS THE OVERVIEW, and that is a structural fact rather than a
// stylistic one: `content/packages/index.typ` windows this note with `limit: 1`,
// so whatever is written above the first blank line is what the shelf reads out.
// Everything below it belongs to this page and to a fully unfurled window.
//
// `tag: "alpha-package"` IS WHAT PUTS IT ON THAT SHELF: the index windows the
// tag rather than naming each package one by one, so a new stub joins the shelf
// by carrying the tag and nothing else has to be edited.
#idea(<rookery-pinboard>, tag: "alpha-package", title: [`@rookery/pinboard`])[
  The `pinboard` package arranges ideas as draggable cards on a board that remembers where each one was put, after the structural method of John McPhee: lay out the components of a piece until a sequence appears among them.

  A board with no arguments is every note in the rookery, as cards:

  ```typ
  #import "@rookery/core:0.1.0": idea, rookery
  #import "@rookery/pinboard:0.1.0": pinboard
  #show: rookery

  #idea("outline", title: [Outline])[..]
  #idea("interview", title: [The interview])[..]

  #pinboard()
  ```

  Pinboard has no query of its own, because rookery already has one: narrow with
  `ideas(..)` and hand the rows in.

  ```typ
  #import "@rookery/core:0.1.0": ideas

  #pinboard(id: "outline-board", notes: ideas(tagged: "outline"), folded: false)
  ```

  `id:` names the board, and naming it is what gives it a memory: positions live
  in the reader's own browser under `rookery-pinboard:<id>`, keyed on each note's
  registry name. So a layout is the reader's rather than the document's — it does
  not travel with the project, and renaming a board starts it empty.

  `layout:` (`"stack"` or `"flow"`) places a card the board has never seen
  before, and only such a card: once something has been dragged, neither the
  layout nor the order of `ideas(..)` moves it again. That is the point of a
  pinboard, and it is also the thing to remember when a change to the query
  appears to do nothing.

  Cards are windows rendered with `backlink: false` — a board showing the whole
  corpus is a view of the notes, not forty references to them, and it should not
  put itself in forty sets of Backlinks.
]
