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
#import "@rheo/rookery:0.1.0": rookery

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
  ]
]

#let template(current-page: none, doc) = {
  show: rookery.with(theme: THEME)

  context if target() == "html" {
    site-header(current-page)
  } else {
    // PDF/EPUB: no nav — there is nowhere to navigate to in a single
    // document. The banner stands in for the header, on the first page only,
    // which is the landing page's job (see index.typ).
  }

  doc
}
