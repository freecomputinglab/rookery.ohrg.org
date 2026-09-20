#import "@rookery/core:0.1.0": rookery
#import "@rookery/search:0.1.0": search-modal

// One colour per kind of idea this site hatches, for the tag pills in an idea's
// hat. The hues are declared once in `style.css`'s `:root`, and named here as
// custom properties rather than copied as hex: the package stringifies whatever
// it is given into the pill's inline `style`, so `var(...)` resolves in the
// browser like any other value. A tag with no entry keeps rookery's neutral pill.
#let TAG-COLORS = (
  concept: (
    text: "var(--tag-concept)",
    background: "color-mix(in oklab, var(--tag-concept) 14%, transparent)",
  ),
  reference: (
    text: "var(--tag-reference)",
    background: "color-mix(in oklab, var(--tag-reference) 14%, transparent)",
  ),
  setup: (
    text: "var(--tag-setup)",
    background: "color-mix(in oklab, var(--tag-setup) 14%, transparent)",
  ),
  faq: (
    text: "var(--tag-faq)",
    background: "color-mix(in oklab, var(--tag-faq) 14%, transparent)",
  ),
  // Not a kind but a warning: every note wearing this tag is alpha software, and
  // the pill should say so before the prose does.
  alpha-package: (
    text: "var(--tag-alpha-package)",
    background: "color-mix(in oklab, var(--tag-alpha-package) 14%, transparent)",
  ),
)

#let THEME = (
  link-color: "rgba(230, 140, 0, 0.16)",
  fold-color: "rgba(255, 190, 40, 0.07)",
  date-color: rgb("#a08a5a"),
  tags-color: TAG-COLORS,
)

// The bar's reading order, which is not the spine's. The spine scans
// alphabetically, and `[spine] include` is the only key that would reorder it —
// but it reorders flatly, discarding the group structure around `packages/`, so
// `packages/bibtex.typ` would publish as `bibtex.html`. That leaves the nav as
// the only place this order can be stated.
//
// A handle this list omits is not dropped: it follows the named ones in spine
// order, so a new top-layer page appears in the bar with no edit here.
#let NAV-ORDER = ("concepts", "reference", "faq", "packages")

// The topbar's entries: every vertebra in the top layer of `content_dir` except
// `index.typ`, which the wordmark already links. Read off the spine rather than
// written out, so dropping `content/packages.typ` next to `faq.typ` puts
// `packages` in the bar with no edit to this file.
//
// This reads `sys.inputs.rheo-context` rather than calling `rheo-context()`,
// which rheo injects into spine files only. What it reaches is spine-wide, so
// the one missing fact is which page this is, and `template` takes that as
// `current-page` from the prelude instead.
#let SITE-PAGES = {
  let flat = sys.inputs
    .at("rheo-context", default: (:))
    .at("spine-flat", default: ())
    .filter(v => v.at("path", default: none) != none and v.at("handle", default: none) != none)

  // A leading segment every spine path shares is rheo's `content_dir`, which is
  // a wrapper and not a section, so strip it before the depth test below. This
  // site declares `content_dir = "content"`; without the strip every path sits
  // one level down and the bar comes out empty. The loop repeats because the
  // setting can name more than one level.
  let paths = flat.map(v => v.path)
  while paths.len() > 0 and paths.first().contains("/") {
    let head = paths.first().split("/").first()
    if not paths.all(p => p.starts-with(head + "/")) { break }
    paths = paths.map(p => p.slice(head.len() + 1))
  }

  // The word this vertebra wears in the bar, or `none` for one that does not
  // belong there. A root file is its own stem. A directory's landing file —
  // `index.typ` or `<dirname>.typ`, the two forms rheo accepts — stands for the
  // whole directory and wears its name. Anything deeper is a page within a
  // section, reached from that section's page rather than from the bar.
  //
  // The test is on the spine path, which is the only thing that can tell the two
  // apart: `packages/index.typ` publishes as `packages.html`, indistinguishable
  // by output path from a root file. Root `index.typ` is the one root file left
  // out, the wordmark already linking it.
  let nav-label(p) = {
    let parts = p.split("/")
    let stem = parts.last().trim(".typ", at: end)
    if parts.len() == 1 {
      if stem == "index" { none } else { stem }
    } else if parts.len() == 2 and (stem == "index" or stem == parts.first()) {
      parts.first()
    } else {
      none
    }
  }

  // `NAV-ORDER` first, then anything it does not name, in spine order.
  // `position` returns `none` for an omitted handle, `len()` sorts those after
  // every named one, and the zipped spine index keeps them stably ordered among
  // themselves.
  let entries = flat
    .zip(paths)
    .map(((v, p)) => (handle: v.handle, label: nav-label(p)))
    .filter(e => e.label != none)

  entries
    .enumerate()
    .sorted(key: ((i, e)) => {
      let rank = NAV-ORDER.position(h => h == e.handle)
      (if rank == none { NAV-ORDER.len() } else { rank }, i)
    })
    .map(((i, e)) => e)
}

#let site-header(current-page) = html.elem("header", attrs: (class: "site-header"))[
  #html.elem("div", attrs: (class: "site-header-inner"))[
    // On the landing page the wordmark is the active nav entry, so it keeps the
    // accent rather than only taking it on hover.
    #let wordmark-class = if current-page == "index" { "wordmark active" } else { "wordmark" }
    #html.elem("span", attrs: (class: wordmark-class), link(label("index"))[rookery])
    #html.elem("nav", attrs: (class: "site-nav", id: "site-nav", aria-label: "Site sections"))[
      #html.elem(
        "ul",
        attrs: (:),
        SITE-PAGES
          .map(p => {
            // A section is active for its pages too: reading `packages:core` is
            // still being in packages, and the handle of a page inside a section
            // is that section's handle plus `:`. A minted idea page carries the
            // `idea:` prefix instead, so it matches no section and nothing is
            // marked, which is the honest answer for a note belonging to none.
            //
            // The link is made from the handle rather than the label: rheo
            // resolves `#link(<handle>)` against the spine and rewrites it to
            // the right depth, so one entry works from a root vertebra and from
            // a minted idea page a directory down.
            let within = (
              type(current-page) == str and current-page.starts-with(p.handle + ":")
            )
            let cls = if p.handle == current-page or within { "active" } else { "" }
            html.elem("li", attrs: (class: cls), link(label(p.handle), p.label))
          })
          .join(),
      )
    ]

    #search-modal(placeholder: "Search ideas")

    // The source of the packages this site documents. Drawn as an inline `svg`
    // rather than fetched as an image, so it takes `currentColor` and follows
    // the bar's hover colour like the nav entries beside it. The path is
    // GitHub's own mark; `viewBox` and `fill-rule` are quoted keys because
    // they are not Typst identifiers.
    #html.elem(
      "a",
      attrs: (
        class: "source-link",
        href: "https://github.com/freecomputinglab/rookery",
        rel: "noopener",
        target: "_blank",
        aria-label: "Source on GitHub",
      ),
      html.elem(
        "svg",
        attrs: (
          "viewBox": "0 0 16 16",
          width: "16",
          height: "16",
          fill: "currentColor",
          aria-hidden: "true",
        ),
        html.elem(
          "path",
          attrs: (
            "fill-rule": "evenodd",
            d: "M8 0C3.58 0 0 3.58 0 8c0 3.54 2.29 6.53 5.47 7.59.4.07.55-.17.55-.38 "
              + "0-.19-.01-.82-.01-1.49-2.01.37-2.53-.49-2.69-.94-.09-.23-.48-.94-.82-1.13-.28-.15-.68-.52-.01-.53.63-.01 "
              + "1.08.58 1.23.82.72 1.21 1.87.87 2.33.66.07-.52.28-.87.51-1.07-1.78-.2-3.64-.89-3.64-3.95 "
              + "0-.87.31-1.59.82-2.15-.08-.2-.36-1.02.08-2.12 0 0 .67-.21 2.2.82.64-.18 1.32-.27 "
              + "2-.27.68 0 1.36.09 2 .27 1.53-1.04 2.2-.82 2.2-.82.44 1.1.16 1.92.08 2.12.51.56.82 "
              + "1.27.82 2.15 0 3.07-1.87 3.75-3.65 3.95.29.25.54.73.54 1.48 0 1.07-.01 1.93-.01 "
              + "2.2 0 .21.15.46.55.38A8.012 8.012 0 0 0 16 8c0-4.42-3.58-8-8-8z",
          ),
          [],
        ),
      ),
    )

    // The hamburger, hidden on desktop and below the responsive breakpoint that
    // collapses `#site-nav` into a dropdown. It comes after `search-modal` in
    // document order because the two are flex siblings with no `order`
    // override, and the search trigger has to stay left of the toggle rather
    // than get swallowed into the menu it opens.
    #html.elem(
      "button",
      attrs: (
        class: "nav-toggle",
        type: "button",
        aria-expanded: "false",
        aria-controls: "site-nav",
        aria-label: "Menu",
      ),
      html.elem("span", attrs: (class: "nav-toggle-bar"), [])
        + html.elem("span", attrs: (class: "nav-toggle-bar"), [])
        + html.elem("span", attrs: (class: "nav-toggle-bar"), []),
    )
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

// The prefix every browser tab wears, so a reader with a dozen open can tell
// which site each belongs to before reading the page's own name.
#let SITE = "Rookery"
#let site-title(name) = SITE + " - " + name

// The template for the standalone page rookery mints per idea, handed to the
// package by `template` below and called by its `.marrow.typ` once per note.
//
// It has to be a named top-level binding: the package stores it on a
// document-wide state, and an inline closure inside `template` would be a
// different value in every vertebra that applies it. It is defined before
// `template` and applies `chrome` rather than `template` so the two need not
// reference each other.
//
// `note` is the note's registry record — title, dates, origin, outbound links.
// It goes unused here, but a site wanting a richer idea-page header has it
// without querying.

#let idea-page(id: none, note: (:), doc) = {
  // The minted page's own `<title>`. The package sets one already, but it hands
  // that value to `rheo-document` outside this template, so the only way to
  // prefix it is to set it again here, where the later `set document` wins.
  //
  // `note.title` is content rather than a string, and `document(title:)` takes
  // either, so joining as content avoids a content-to-string walk the package
  // does not export. The empty-`note` branch is the landing page, the one minted
  // page that is not an idea.
  let name = if note.len() == 0 {
    [Ideas]
  } else if note.at("title", default: none) != none {
    note.title
  } else {
    // Untitled ideas fall back to the slug, as the package does. `id` is the
    // full `idea:etal`, and the slug is what follows the separator.
    raw(id.split(":").last())
  }
  set document(title: [#SITE - #name])
  show: chrome.with(current-page: id)
  doc
}

// One bibliography for the whole rookery, alongside the theme and for the same
// reason: it is a document-wide value, so this is the one file that asks for it.
//
// `bytes(read(...))` rather than a path, because Typst resolves a path against
// the file the call appears in, and rookery's own `#bibliography` call lives
// inside the package — a path would be looked for beside the package's
// `lib.typ`. The path is root-absolute so the `.bib` can sit beside the pages
// that cite it rather than counting directories up from `_lib/`.
//
// No `style:`, since rookery defaults to author-date: citation numbering in
// Typst is document-wide and cannot be reset.
#let BIBLIOGRAPHY = arguments(bytes(read("/content/references.bib")))

// No vertebra applies this by hand. `[spine] prelude` splices
// `_lib/prelude.typ` into every page, and that is the one place writing the
// `#show: template`, so a new page in `content/` is a `#set document(title: ..)`
// and prose and nothing else.
//
// `current-page` arrives from the prelude as that vertebra's own
// `rheo-context().handle`, the one per-file field rheo injects and the one fact
// this file cannot read for itself. For a root file the handle is the stem,
// which is what the nav's active marker compares against.
#let template(current-page: none, doc) = {
  show: rookery.with(
    theme: THEME,
    idea-page-template: idea-page,
    // The default, and what this site's prose claims it uses. An unfurl of `0`
    // means no windowing anywhere, which renders every transclusion as a link
    // row.
    window-unfurl: 1,
    bibliography: BIBLIOGRAPHY,
  )
  show: chrome.with(current-page: current-page)
  doc
}
