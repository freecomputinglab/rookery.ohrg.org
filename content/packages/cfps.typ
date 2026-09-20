#set document(
  title: "Rookery - @rookery/cfps",
  date: datetime(year: 2026, month: 8, day: 20),
)

#idea(<rookery-cfps>, tag: "alpha-package", title: [`@rookery/cfps`])[
  The `cfps` package models a venue and the calls it puts out, each call being a single idea that carries its deadline, its portal, and what happened when it was answered.

  ```typ
  #import "@rookery/core:0.1.0": rookery
  #import "@rookery/cfps:0.1.0": cfps
  #show: rookery

  #let TODAY = datetime(year: 2026, month: 6, day: 1)
  #let (venue, cfp, cfp-state, panel) = cfps(kinds: (
    postdoc: (sort: "job", ladder: (transit: ("submitted",), terminal: ("offered", "rejected"))),
  ))

  #venue("acme", title: [Acme University])[A programme that runs every year.]

  #cfp(
    "acme-postdoc-26",
    venue: <acme>,
    kind: "postdoc",
    deadline: datetime(year: 2026, month: 1, day: 1),
    today: TODAY,
  )[A round that lapsed with nothing sent.]

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

  #panel(state: "settled", today: TODAY)
  ```

  The venue is the thing that recurs and the call is the round, so a programme
  you apply to three years running is one `#venue` and three `#cfp`s pointing at
  it by label. State is derived from the dates rather than declared: a round with
  a future deadline and nothing sent is _open_, one with a `submitted` stage and
  no terminal rung is _in flight_, one that reached `offered` or `rejected` is
  _settled_, and `#panel` filters on exactly those words.

  `kind:` is required and must name a key of the `kinds:` you bound, which is
  what makes a typo fail at the call rather than quietly produce a round no
  ladder governs. Stage names inside `timeline:` are checked against that kind's
  ladder for the same reason. As everywhere in this family, `today:` is explicit
  and has no fallback.
]
