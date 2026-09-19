#set document(
  title: "Rookery - @rookery/timeline",
  date: datetime(year: 2026, month: 9, day: 19),
)

// A one-line stub: the package is named, linkable across the rookery, and says
// in a sentence what it is for. THAT SENTENCE IS THE IDEA'S FIRST BLOCK, which
// is what `content/packages/index.typ` shows with `limit: 1` — so whatever is
// written above the first blank line here is the overview the shelf reads out.
// The rest of the page fills in when the package does.
// `tag: "alpha-package"` IS WHAT PUTS IT ON THAT SHELF: the index windows the
// tag rather than naming each package one by one, so a new stub joins the shelf
// by carrying the tag and nothing else has to be edited.
#idea(<rookery-timeline>, tag: "alpha-package", title: [`@rookery/timeline`])[
  The `timeline` package keeps a dated lifecycle log on the tags of an idea, from when it was created to whatever stages a ladder of its own names, and draws the rail that orders them.
]
