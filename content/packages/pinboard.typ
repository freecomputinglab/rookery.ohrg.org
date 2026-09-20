#set document(
  title: "Rookery - @rookery/pinboard",
  date: datetime(year: 2026, month: 8, day: 20),
)

#idea(<rookery-pinboard>, tag: "alpha-package", title: [`@rookery/pinboard`])[
  Arranges ideas as draggable cards on a board that remembers where each one was put, after the structural method of John McPhee, which lays out the components of a piece until a sequence appears among them.

  A board with no arguments is every note in the rookery, as cards.

  ```typ
  #import "@rookery/core:0.1.0": idea, rookery
  #import "@rookery/pinboard:0.1.0": pinboard
  #show: rookery

  #idea("outline", title: [Outline])[..]
  #idea("interview", title: [The interview])[..]

  /* Cards are windows rendered without backlinks, so a board showing the whole
     corpus is a view of the notes rather than forty references to them. */
  #pinboard()
  ```

  == Narrowing and remembering a board

  Pinboard has no query of its own, because rookery already has one.
  Narrow with `ideas(..)` and hand the rows in.

  ```typ
  #import "@rookery/core:0.1.0": ideas

  /* Naming a board gives it a memory. Positions live in the reader's own
     browser under rookery-pinboard:<id>, keyed on each note's registry name, so
     a layout belongs to the reader rather than the document and renaming a
     board starts it empty. */
  #pinboard(id: "outline-board", notes: ideas(tagged: "outline"), folded: false)

  /* layout: places a card the board has never seen before, and only such a
     card. Once something has been dragged, neither the layout nor the order of
     ideas(..) moves it again. */
  #pinboard(id: "flow-board", layout: "flow")
  ```
]
