#import "@rheo/rookery:0.3.0": rookery
#import "@rheo/rookery-search:0.3.0": search-modal

#let THEME = (
  link-color: "rgba(230, 140, 0, 0.16)",
  fold-color: "rgba(255, 190, 40, 0.07)",
  date-color: rgb("#a08a5a"),
)

#let site-pages = (
  (handle: "concepts", title: "Concepts"),
  (handle: "install", title: "Install"),
  (handle: "faq", title: "FAQ"),
)

#let site-header(current-page) = html.elem("header", attrs: (class: "site-header"))[
  #html.elem("div", attrs: (class: "site-header-inner"))[
    // On the landing page the wordmark IS the active nav entry, so it keeps
    // the accent rather than only taking it on hover.
    #let wordmark-class = if current-page == "index" { "wordmark active" } else { "wordmark" }
    #html.elem("span", attrs: (class: wordmark-class), link(label("index"))[rookery])
    #html.elem("nav", attrs: (class: "site-nav", aria-label: "Site sections"))[
      #html.elem(
        "ul",
        attrs: (:),
        site-pages
          .map(p => {
            let cls = if p.handle == current-page { "active" } else { "" }
            html.elem("li", attrs: (class: cls), link(label(p.handle), p.title))
          })
          .join(),
      )
    ]

    #search-modal(placeholder: "Search ideas")
  ]
]

#let chrome(current-page: none, doc) = {
  set table(
    stroke: (x: none, y: 0.5pt + rgb("#e6e6e6")),
    inset: (x: 0.5em, y: 0.45em),
    align: left + top,
  )
  show table.cell.where(y: 0): it => context if target() == "html" { it } else { smallcaps(it) }

  context if target() == "html" {
    site-header(current-page)
  } else {
    // No header in PDF and EPUB
  }

  doc
}

// The template for the standalone page rookery mints per idea, handed to the
// package by `template` below and called by its `.marrow.typ` once per note.
// `id` is the note's full id, so the nav entry for `idea:rookery` is simply
// not one of `site-pages` and nothing is marked active — a note page belongs
// to no section, which is the honest answer.
//
// A NAMED top-level binding, deliberately: the package stores this on a
// document-wide state, and an inline closure written inside `template` would
// be a different value in every vertebra that applies it. `note` (the note's
// registry record: title, dates, origin, outbound links) goes unused here,
// but a site wanting a richer idea-page header has it without querying.
//
// Defined before `template` and applying `chrome` rather than `template` —
// the two would otherwise have to reference each other.
#let idea-page(id: none, note: (:), doc) = {
  show: chrome.with(current-page: id)
  doc
}

// One bibliography for the whole rookery, alongside the theme and for the same
// reason: it is a document-wide value, so every vertebra has to ask for the
// same thing and this is the one file that asks.
//
// `bytes(read(...))` rather than a path. Typst resolves a path against the file
// the call appears in, and rookery's own `#bibliography` call lives inside the
// package — a path would be looked for next to the package's `lib.typ`. Reading
// here resolves against THIS file, which is where `references.bib` sits.
//
// No `style:`: rookery defaults to an author-date style, because citation
// numbering in Typst is document-wide and cannot be reset.
#let BIBLIOGRAPHY = arguments(bytes(read("references.bib")))

#let template(current-page: none, doc) = {
  show: rookery.with(
    theme: THEME,
    idea-page-template: idea-page,
    // `1` — the default, and what this site's own prose has always claimed
    // ("Because this documentation uses the default depth of `1`"). It read `0`,
    // which under the recursion semantics means NO WINDOWING ANYWHERE, so every
    // transclusion on the site rendered as a link row.
    window-depth: 1,
    bibliography: BIBLIOGRAPHY,
  )
  show: chrome.with(current-page: current-page)
  doc
}
