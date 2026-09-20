#set document(
  title: "Rookery - @rookery/cfps",
  date: datetime(year: 2026, month: 8, day: 20),
)

#idea(<rookery-cfps>, tag: "alpha-package", title: [`@rookery/cfps`])[
  Models a venue and the calls it puts out.
  Each call is a single idea carrying its deadline, its portal, and what happened when it was answered.

  The venue is the thing that recurs and the call is the round, so a programme you apply to three years running is one `#venue` and three `#cfp`s pointing at it by label.

  ```typ
  #import "@rookery/core:0.1.0": rookery
  #import "@rookery/cfps:0.1.0": cfps
  #show: rookery

  #let TODAY = datetime(year: 2026, month: 6, day: 1)

  /* Every call names one of these kinds, so a typo fails at the call rather
     than minting a round no ladder governs. */
  #let (venue, cfp, cfp-state, panel) = cfps(kinds: (
    postdoc: (sort: "job", ladder: (transit: ("submitted",), terminal: ("offered", "rejected"))),
  ))

  #venue("acme", title: [Acme University])[A programme that runs every year.]

  /* State comes from the dates rather than a field. A future deadline with
     nothing sent is open. */
  #cfp(
    "acme-postdoc-26",
    venue: <acme>,
    kind: "postdoc",
    deadline: datetime(year: 2026, month: 1, day: 1),
    today: TODAY,
  )[A round that lapsed with nothing sent.]

  /* A submitted stage and no terminal rung is in flight, and a terminal rung
     settles the round. Stage names are checked against the kind's ladder. */
  #cfp(
    "acme-postdoc-25",
    venue: <acme>,
    kind: "postdoc",
    deadline: datetime(year: 2025, month: 1, day: 1),
    timeline: (
      submitted: datetime(year: 2024, month: 12, day: 1),
      offered: datetime(year: 2025, month: 2, day: 1),
    ),
    today: TODAY,
  )[A round that was answered, and settled.]

  /* Panels filter on exactly those words. Pass today: everywhere, as it has no
     fallback. */
  #panel(state: "settled", today: TODAY)
  ```
]
