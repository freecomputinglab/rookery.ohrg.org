#set document(
  title: "Rookery - @rookery/search",
  date: datetime(year: 2026, month: 8, day: 20),
)

#idea(<rookery-search>, tag: "alpha-package", title: [`@rookery/search`])[
  Provides a full-text search interface for rookery ideas, as seen in #link("https://rookery.ohrg.org")[rookery's docsite], or #link("https://ohrg.org")[one] of #link("https://weeknotes.ohrg.org")[these] #link("https://maths.ohrg.org")[sites].

  Ideas are ranked by name, by title, and by full text.
  This index can power a search modal or an inline filter panel.

  ```typ
  #import "@rookery/core:0.1.0": rookery
  #import "@rookery/search:0.1.0": search-bar, filter-panel
  #show: rookery

  /* Modal-based search bar with a limited number of ideas in the base view. */
  #search-bar(placeholder: "Find a note", limit: 12)

  /* Inline search panel with clickable pills as preset searches for certain tags. */
  #filter-panel(tag: "todo", pills: ("ready", "blocked", "epic-jobs"))
  ```

  == Scoping searches

  You can specify `tags:` when using the UX elements to narrow the search space at compile-time:

  ```typ
  #search-bar(tags: "phd", elem-id: "phd-index", placeholder: "phd notes")
  #search-bar(tags: "trip", elem-id: "trip-index", placeholder: "trip notes")
  ```
]
