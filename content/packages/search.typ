#set document(
  title: "Rookery - @rookery/search",
  date: datetime(year: 2026, month: 8, day: 20),
)

#idea(<rookery-search>, tag: "alpha-package", title: [`@rookery/search`])[
  The `search` package ranks the ideas in a rookery by name, by title and by full text, and puts that ranking behind an inline search bar, a site-wide overlay and a faceted filter panel.

  This site uses the overlay — `#search-modal(placeholder: "Search ideas")` sits
  in the topbar, and is the magnifying glass above. The inline bar is the same
  index, in the flow of a page rather than behind a key:

  ```typ
  #import "@rookery/core:0.1.0": rookery
  #import "@rookery/search:0.1.0": search-bar
  #show: rookery

  #search-bar(placeholder: "Find a note", limit: 12)
  ```

  An author's `tags:` narrows the corpus at build time, which is a different axis
  from the `tags:` clause a reader types into the box — that filters within
  whatever the bar was given. Two scoped bars on one page keep their own indexes:

  ```typ
  #search-bar(tags: "phd", elem-id: "phd-index", placeholder: "phd notes")
  #search-bar(tags: "trip", elem-id: "trip-index", placeholder: "trip notes")
  ```

  Where the question is which notes rather than which words, the filter panel
  pills a set of tags and narrows a list as they are pressed:

  ```typ
  #import "@rookery/search:0.1.0": filter-panel

  #filter-panel(tag: "todo", pills: ("ready", "blocked", "epic-jobs"))
  ```

  `#panel` is that same chrome over a `tag-index` projection rather than over
  tags — for a list with real columns to sort and facet on. It never builds an
  index of its own; it is handed the rows it should show.

  Every surface here is HTML, and renders as nothing at all in PDF or EPUB: a
  search box is a thing you type into. Tag matching is by prefix, so `tags:note`
  also reaches `notebook`, and a tag is never a scoring term — searching `phd`
  finds the note _called_ that, not the notes tagged with it.
]
