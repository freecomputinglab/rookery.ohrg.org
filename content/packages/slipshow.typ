#set document(
  title: "Rookery - @rookery/slipshow",
  date: datetime(year: 2026, month: 8, day: 20),
)

#idea(<rookery-slipshow>, tag: "alpha-package", title: [`@rookery/slipshow`])[
  Renders a set of ideas as an endlessly scrolling presentation, with a camera that moves between slips rather than cutting from one slide to the next.

  A slip is an idea, so a deck is a query over ideas.

  ```typ
  #import "@rookery/core:0.1.0": rookery
  #import "@rookery/slipshow:0.1.0": slip, slipshow
  #show: rookery

  #slip("opening")[Welcome. This deck has three slips and no options.]
  #slip("middle")[Each `#slip` is a note the deck below queries by tag.]
  #slip("closing")[The end.]

  /* Queried decks sort on the slip-order tag, and take order: "created" or an
     explicit list of names instead. Give a deck a query or a list of slips, as
     a deck given both, or neither, panics rather than guessing. */
  #slipshow(tags: "slip")
  ```

  == Ordering the deck by hand

  The other route hands the deck its slips directly, in the order they should be read.
  These are already ordered, so passing `order:` alongside them is an error rather than a redundancy.

  ```typ
  #slipshow(slips: (
    slip("intro", title: [Welcome], fullscreen: true)[The opening slip.],
    slip("closing")[The last one.],
  ))
  ```

  == Moving the camera

  Name what the camera does arriving at a slip, per deck or per slip.
  The camera is HTML, so on a paged target every slip prints in order, without reveal, rows or backgrounds.

  ```typ
  /* reveal: false renders the whole deck up front instead of one slip at a
     time, and background: takes a Typst value rather than a path string. */
  #slipshow(tags: "slip", enter: "scroll", reveal: false)
  #slip("cover", enter: "jump", background: image("cover.png"))[..]
  ```
]
