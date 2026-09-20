#set document(
  title: "Rookery - @rookery/meetings",
  date: datetime(year: 2026, month: 8, day: 20),
)

#idea(<rookery-meetings>, tag: "alpha-package", title: [`@rookery/meetings`])[
  Mints a meeting as an idea, recording who was in the room, when it happened, and what was said.

  A meeting names the people it was with by pointing at the ideas that already stand for them, so the record and the person are the same kind of thing.

  ```typ
  #import "@rookery/core:0.1.0": idea, rookery
  #import "@rookery/meetings:0.1.0": meeting
  #show: rookery

  #idea("doshi-velez-finale", title: [Finale Doshi-Velez])[A person.]

  /* The title is synthesized from the participants and the date, coming out as
     "Meeting with Finale Doshi-Velez on 10.9.26". A reference date has to come
     from somewhere, whether today: here, today: on the factory below, or the
     document's own #set document(date: ..). There is no wall-clock fallback. */
  #meeting(
    <doshi-velez-26-9-10>,
    with: <doshi-velez-finale>,
    on: datetime(year: 2026, month: 9, day: 10),
    today: datetime(year: 2026, month: 9, day: 10),
  )[
    What was said.
  ]
  ```

  == Binding a page tag

  Where a whole site's meetings share a page tag, bind the constructor once and write the tag nowhere else.

  ```typ
  #import "@rookery/meetings:0.1.0": meetings

  #let meeting = meetings("digital-theory-lab", today: TODAY)
  #meeting(<blix-27-8-26>, with: <hagen-blix>, on: d)[..]
  ```
]
