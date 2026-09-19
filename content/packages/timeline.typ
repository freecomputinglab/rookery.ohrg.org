#set document(
  title: "Rookery - @rookery/timeline",
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
#idea(<rookery-timeline>, tag: "alpha-package", title: [`@rookery/timeline`])[
  The `timeline` package keeps a dated lifecycle log on the tags of an idea, from when it was created to whatever stages a ladder of its own names, and draws the rail that orders them.

  A lifecycle is a dictionary of stage names to dates, folded into the note's own
  tags — so it travels with the note, and any view that can read tags can read
  it:

  ```typ
  #import "@rookery/core:0.1.0": idea, rookery
  #import "@rookery/timeline:0.1.0": timeline-tags, timeline-view
  #show: rookery

  #let NOW = datetime(year: 2027, month: 1, day: 5)
  #let wolf = timeline-tags(
    deadline: datetime(year: 2026, month: 11, day: 1),
    timeline: (
      submitted:         datetime(year: 2026, month: 10, day: 28),
      longlisted:        datetime(year: 2026, month: 12, day: 15),
      "first-interview": datetime(year: 2027, month: 1, day: 20),
    ),
  )

  #idea("wolf", tags: wolf)[A round in flight.]
  #timeline-view((created: datetime(year: 2026, month: 10, day: 1)), wolf, today: NOW)
  ```

  Only three stage names are reserved — `scheduled`, `deadline` and `closed` —
  and every other rung is vocabulary you invent for the thing you are tracking.
  A stage may also be a dictionary rather than a bare date, in which case it
  needs a `timestamp:` and may carry a `note:`.

  The package also ships a skin, so the dates can be arguments instead of a
  fragment you merge yourself:

  ```typ
  #import "@rookery/timeline:0.1.0": idea, rookery, window

  #idea("ship", deadline: d, timeline: (submitted: d2))[Cut the release.]
  ```

  Writing the same stage twice — once as a named argument and again inside
  `timeline:` — is an error rather than a last-one-wins, and Typst will not let a
  dictionary repeat a key at all, so a stage that genuinely happens more than
  once is numbered (`review-1`, `review-2`) and matched by a `review-*` family
  rung.
]
