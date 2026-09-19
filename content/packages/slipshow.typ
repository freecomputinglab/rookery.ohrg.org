#set document(
  title: "Rookery - @rookery/slipshow",
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
#idea(<rookery-slipshow>, tag: "alpha-package", title: [`@rookery/slipshow`])[
  The `slipshow` package renders a set of ideas as an endlessly scrolling presentation, with a camera that moves between slips rather than cutting from one slide to the next.

  A slip is an idea, so a deck is a query over ideas. The shortest form writes
  three of them and asks for everything tagged `slip`:

  ```typ
  #import "@rookery/core:0.1.0": rookery
  #import "@rookery/slipshow:0.1.0": slip, slipshow
  #show: rookery

  #slip("opening")[Welcome. This deck has three slips and no options.]
  #slip("middle")[Each `#slip` is a note the deck below queries by tag.]
  #slip("closing")[The end.]

  #slipshow(tags: "slip")
  ```

  The other route hands the deck its slips directly, in the order they should be
  read:

  ```typ
  #slipshow(slips: (
    slip("intro", title: [Welcome], fullscreen: true)[The opening slip.],
    slip("closing")[The last one.],
  ))
  ```

  Pick one route or the other — a deck given both, or neither, panics rather than
  guessing. The queried route sorts on the `slip-order` tag by default and takes
  `order: "created"` or an explicit list of names instead; the explicit route is
  already ordered, so passing `order:` alongside it is an error rather than a
  redundancy.

  `enter:` names what the camera does arriving at a slip, per deck or per slip,
  and `reveal: false` renders the whole deck up front instead of one slip at a
  time. A slip's `background:` takes a Typst value — `image("cover.png")`, a
  colour, a gradient — never a path string.

  The camera is HTML: on a paged target every slip prints in order, without
  reveal, rows or backgrounds. This is a from-scratch camera engine rather than a
  wrapper around slipshow's own JavaScript, so it moves between slips and does
  nothing else — there is no `pause` and no incremental build.
]
