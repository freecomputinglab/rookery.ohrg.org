#set document(
  title: "Rookery - @rookery/meetings",
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
#idea(<rookery-meetings>, tag: "alpha-package", title: [`@rookery/meetings`])[
  The `meetings` package mints a meeting as an idea: who was in the room, when it happened, and what was said.

  A meeting names the people it was with by pointing at the ideas that already
  stand for them, so the record and the person are the same kind of thing:

  ```typ
  #import "@rookery/core:0.1.0": idea, rookery
  #import "@rookery/meetings:0.1.0": meeting
  #show: rookery

  #idea("doshi-velez-finale", title: [Finale Doshi-Velez])[A person.]

  #meeting(
    <doshi-velez-26-9-10>,
    with: <doshi-velez-finale>,
    on: datetime(year: 2026, month: 9, day: 10),
    today: datetime(year: 2026, month: 9, day: 10),
  )[
    What was said.
  ]
  ```

  The title is synthesised rather than written — the meeting above comes out as
  _Meeting with Finale Doshi-Velez on 10.9.26_ — because a meeting's identity is
  its participants and its date, and typing those twice is how the two drift
  apart.

  Where a whole site's meetings share a page tag, bind the constructor once and
  write the tag nowhere else:

  ```typ
  #import "@rookery/meetings:0.1.0": meetings

  #let meeting = meetings("digital-theory-lab", today: TODAY)
  #meeting(<blix-27-8-26>, with: <hagen-blix>, on: d)[..]
  ```

  Three tag keys are the package's own — `meeting`, the valued `meeting-with`,
  and the `occurred` timeline stage — and the pair `meeting-with-of` and
  `occurred-of` reads them back off any note's tag dictionary. A reference date
  has to come from somewhere, whether as `today:` on the factory, `today:` on the
  call, or the document's own `#set document(date: ..)`; there is no wall-clock
  fallback anywhere in the package.
]
