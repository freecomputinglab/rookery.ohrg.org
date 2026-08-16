// Site chrome, and the one place `@rheo/rookery` is configured.
//
// `#show: rookery` has to be applied in EVERY vertebra that uses the package —
// imports are per-file, so there is no way for one file to install it for the
// others. Wrapping it in the site template is how that requirement gets met
// once: a page writes `#show: template.with(...)` and gets the chrome, the
// prefix, the theme and the `ref` rule together.
//
// It works because `show: f` inside a function body applies to the rest of
// that body — including the `doc` returned at the end — exactly as it does at
// the top of a file.
#import "@rheo/rookery:0.1.1": rookery
// Search ships as its own package. Both imports have to be written HERE, in the
// site's own file: rheo scans only a project's own `.typ` files for package
// imports, so a package reached transitively through another one contributes
// nothing — no stylesheet, no script, and (for rookery) no minted note pages at
// all, which would leave the search index with nothing to link to.
#import "@rheo/rookery-search:0.1.0": search-bar

// Ids on this site use rookery's default `idea:<name>` prefix, so no
// `prefix:` argument is passed below. The theme replaces rookery's default
// light-blue/purple pair with an amber one — ONE document-wide value: every
// vertebra has to ask for the same thing, which is why it is set in one file.
#let THEME = (
  link-color: "rgba(230, 140, 0, 0.16)",
  fold-color: "rgba(255, 190, 40, 0.07)",
  date-color: rgb("#a08a5a"),
)

// ============================================================
// The spine, as data. One entry per page, in reading order.
// ============================================================
// `handle` is rheo's own name for a vertebra — the same string a page passes
// as `current-page`, and the label `#link` resolves against.
#let site-pages = (
  // (handle: "index", title: "Home"),
  (handle: "concepts", title: "Concepts"),
  (handle: "install", title: "Install"),
  (handle: "faq", title: "FAQ"),
)

// The header nav. Every page link goes through `link(label(<handle>))` rather
// than a hand-written `href`, because rheo rewrites exactly that form into a
// DEPTH-RELATIVE url: `guide/intro.html` is one level down, so its links come
// out `../index.html` while the same nav on the home page emits `index.html`.
// Writing `./index.html` by hand — as a flat site can — would 404 from the
// nested vertebra.
//
// The wordmark and each entry are wrapped in an element carrying the class,
// with Typst's `link` inside it, since only Typst can compute those hrefs. So
// the CSS hooks are `.wordmark a` and `.site-nav a`, not the anchors
// themselves.
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
    // After the nav, so `.site-nav`'s `margin-left: auto` pushes both to the
    // far end of the bar and the search sits last. It goes inside
    // `.site-header-inner` rather than after the header, because it belongs to
    // the same flex row as the wordmark and the nav — the bar is phrasing
    // content and can sit anywhere text can, which is what makes that possible.
    //
    // `limit: 12` rather than the package's default 8: this site is around
    // twenty-five notes, so twelve is a real slice of the rookery rather than a
    // truncation, and still short enough to read without scrolling.
    #search-bar(placeholder: "Search ideas", limit: 12)
  ]
]

// The chrome alone, with no `#show: rookery` in it. Split out from `template`
// below because BOTH a vertebra and a minted note page need it, and only a
// vertebra needs the package configured: a minted page is spliced in after
// every vertebra has already set the prefix, theme and window depth, so
// re-applying `rookery` there would append a second round of identical state
// updates for no gain.
#let chrome(current-page: none, doc) = {
  context if target() == "html" {
    site-header(current-page)
  } else {
    // PDF/EPUB: no nav — there is nowhere to navigate to in a single
    // document. The banner stands in for the header, on the first page only,
    // which is the landing page's job (see index.typ).
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
    window-depth: 0,
    bibliography: BIBLIOGRAPHY,
  )
  show: chrome.with(current-page: current-page)
  doc
}
