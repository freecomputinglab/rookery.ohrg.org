#set document(
  title: "Rookery - @rookery/timeline",
  date: datetime(year: 2026, month: 8, day: 20),
)

#idea(<rookery-timeline>, tag: "alpha-package", title: [`@rookery/timeline`])[
  Keeps a dated lifecycle log on the tags of an idea, from when it was created to whatever stages a ladder of its own names, and draws the rail that orders them.

  A lifecycle is a dictionary of stage names to dates, folded into the note's own tags, so it travels with the note and any view that can read tags can read it.

  ```typ
  #import "@rookery/core:0.1.0": idea, rookery
  #import "@rookery/timeline:0.1.0": timeline-tags, timeline-view
  #show: rookery

  #let NOW = datetime(year: 2027, month: 1, day: 5)

  /* Three stage names are reserved, scheduled, deadline and closed. Every other
     rung is vocabulary you invent for the thing you are tracking. A stage may
     also be a dictionary rather than a bare date, needing a timestamp: and
     taking an optional note:. */
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

  == Taking the dates as arguments

  The package also ships a skin, so the stages can be arguments instead of a fragment you merge yourself.

  ```typ
  #import "@rookery/timeline:0.1.0": idea, rookery, window

  /* Writing the same stage twice, once as an argument and again inside
     timeline:, is an error rather than a last-one-wins. Number a stage that
     genuinely happens more than once (review-1, review-2) and match it with a
     review-* family rung. */
  #idea("ship", deadline: d, timeline: (submitted: d2))[Cut the release.]
  ```
]
