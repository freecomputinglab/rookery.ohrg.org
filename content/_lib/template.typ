#import "@rookery/core:0.1.0": rookery
#import "@rookery/search:0.1.0": search-modal

// One colour per kind of idea this site hatches, for the tag pills in an
// idea's hat — rookery 0.4.0's `theme.tags-color`, which only the pills use.
//
// CSS custom properties rather than hex literals: the hues themselves are
// declared once, in `style.css`'s `:root` as `--tag-concept` and friends, where
// the outline-row and search-chip rules for the same tags also read them. The
// package stringifies whatever it is given straight into the pill's inline
// `style`, so `var(...)` resolves in the browser like any other value and there
// is no second copy of a colour to keep in step.
//
// A tag with no entry here keeps rookery's own neutral pill, which is the right
// answer for a tag this site does not use as a kind.
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
  // NOT A KIND — a warning. Orange, because every note wearing it is alpha
  // software the reader is being told to use at their own risk, and the pill
  // should say so before the prose does. Same two-key shape as the kinds, so
  // the hue itself stays declared once in `style.css`.
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

// THE TOPBAR'S ENTRIES: every vertebra in the top layer of `content_dir` except
// `index.typ`, which the wordmark already links. Read off the spine rather than
// written out here, so dropping `content/packages.typ` next to `faq.typ` puts
// `packages` in the bar with no edit to this file — which is the whole point of
// a derived nav over a hand-kept list.
//
// `sys.inputs.rheo-context` rather than `rheo-context()`: rheo injects that
// helper into each SPINE file's scope only, and this file is excluded from the
// spine. The half it does reach — `spine-flat` and the rest — is spine-WIDE, so
// the one thing missing is "which page is this", which `template` takes as
// `current-page` from the prelude instead.
//
// A SECTION IS A TOP-LAYER PAGE, and a page inside it is not. `packages/`
// carries a page per package and a landing file that windows them all, and it
// is the landing file alone that belongs in the bar — `packages/core.typ` is
// reached from that page, not from the topbar. Output path cannot tell the two
// apart (`packages/index.typ` publishes as `packages.html`, indistinguishable
// from a root file); the SPINE path can, and it is the one this reads.
//
// THE STEM IS THE LABEL — the directory's name for a section — not
// `spine-flat`'s `title`, which since rheo 0.6.0 is
// purely path-derived anyway ("Faq" for `faq.typ`, not how the site spells it).
// `.site-nav a` is `text-transform: uppercase` in `style.css`, so the bar reads
// CONCEPTS / FAQ either way and the cased spelling never had a job here.
//
// `handle`, NOT the stem, is what the link is made from: rheo's link rule
// resolves `#link(<handle>)` against `spine-flat` and rewrites it to the right
// depth, so one entry works from a root vertebra and from a minted idea page a
// directory down. The stem is only the visible word, and it is also what
// `current-page` is compared against, the two being the same for a root file.
// THE BAR'S OWN ORDER, which is a reading order and not the spine's. The spine
// scans alphabetically (CONCEPTS / FAQ / PACKAGES / REFERENCE), and `[spine]
// include` — the one key that would reorder it — is a FLAT reorder: it
// discards the group structure around `packages/`, so `packages/bibtex.typ`
// would publish as `bibtex.html` with the handle `bibtex` rather than
// `packages:bibtex`. The nav is therefore the only place this order can be
// stated, and it is stated here by handle.
//
// A handle absent from this list is not dropped — it follows the listed ones in
// spine order, so a new top-layer page still appears in the bar with no edit
// here, and this file only has an opinion about the pages it names.
#let NAV-ORDER = ("concepts", "reference", "faq", "packages")

#let SITE-PAGES = {
  let flat = sys.inputs
    .at("rheo-context", default: (:))
    .at("spine-flat", default: ())
    .filter(v => v.at("path", default: none) != none and v.at("handle", default: none) != none)

  // A LEADING SEGMENT EVERY SPINE PATH SHARES is rheo's `content_dir` — a
  // wrapper nobody named as a section — so it is stripped before the depth test.
  // This site declares `content_dir = "content"`, so without this every path is
  // one level down and the bar would come out empty. Repeated, because the
  // setting can name more than one level.
  let paths = flat.map(v => v.path)
  while paths.len() > 0 and paths.first().contains("/") {
    let head = paths.first().split("/").first()
    if not paths.all(p => p.starts-with(head + "/")) { break }
    paths = paths.map(p => p.slice(head.len() + 1))
  }

  // The word this vertebra wears in the bar, or `none` for one that does not
  // belong there. A root file is its own stem; a directory's landing file —
  // `index.typ`, or `<dirname>.typ`, the two forms rheo accepts — stands for
  // the whole directory and wears its name; anything deeper is a page WITHIN a
  // section, reached from that section's page rather than from the bar. Root
  // `index.typ` is the one root file left out, the wordmark already linking it.
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

  // `NAV-ORDER` first, then anything it does not name, in spine order — the
  // order rheo settled on, so an unlisted page lands where the spine put it
  // rather than somewhere arbitrary. `position` returns `none` for a handle the
  // list omits, and `len()` sorts those after every named one while `zip`ping
  // the spine index in keeps them stably ordered among themselves.
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
    // On the landing page the wordmark IS the active nav entry, so it keeps
    // the accent rather than only taking it on hover.
    #let wordmark-class = if current-page == "index" { "wordmark active" } else { "wordmark" }
    #html.elem("span", attrs: (class: wordmark-class), link(label("index"))[rookery])
    #html.elem("nav", attrs: (class: "site-nav", id: "site-nav", aria-label: "Site sections"))[
      #html.elem(
        "ul",
        attrs: (:),
        SITE-PAGES
          .map(p => {
            // A SECTION IS ACTIVE FOR ITS PAGES TOO: reading
            // `packages:core` is still being in PACKAGES, and the handle of a
            // page inside a section is that section's handle plus `:`. A
            // minted idea page carries the `idea:` prefix instead, so it
            // matches no section and nothing is marked — which is the honest
            // answer for a note belonging to none.
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

    // Left of nothing on desktop — `.nav-toggle` is hidden there and this
    // sits at the end of the bar same as always. Below the Responsive
    // breakpoint it's what collapses `#site-nav` into a dropdown, so it goes
    // AFTER search-modal in document order: the two are flex siblings with no
    // `order` override, so source order is display order, and the search
    // trigger has to stay left of the toggle rather than get swallowed into
    // the menu it opens.
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

// The template for the standalone page rookery mints per idea, handed to the
// package by `template` below and called by its `.marrow.typ` once per note.
// `id` is the note's full name, so the nav entry for `idea:rookery` is simply
// not one of `SITE-PAGES` and nothing is marked active — a note page belongs
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
// The site prefix every browser tab wears, so a reader with a dozen of them
// open can tell which site each belongs to before reading the page's own name.
#let SITE = "Rookery"
#let site-title(name) = SITE + " - " + name

#let idea-page(id: none, note: (:), doc) = {
  // The minted page's own `<title>`. The package sets one already — the note's
  // title, or its slug where it has none, and "Ideas" for the landing page —
  // but it hands `rheo-document` that value OUTSIDE this template, so the only
  // way to prefix it is to set it again here, where a later `set document`
  // wins.
  //
  // `note.title` is CONTENT, not a string, and `document(title:)` takes either;
  // joining with content rather than flattening avoids needing a
  // content-to-string walk the package does not export. The empty-`note` branch
  // is the landing page, which is the one minted page that is not an idea.
  let name = if note.len() == 0 {
    [Ideas]
  } else if note.at("title", default: none) != none {
    note.title
  } else {
    // Untitled: the package falls back to the slug, and so do we — `id` is the
    // full `idea:etal`, and the slug is what follows the prefix separator.
    raw(id.split(":").last())
  }
  set document(title: [#SITE - #name])
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
// here is what puts the resolution back under this project's control.
//
// ROOT-ABSOLUTE, not `../references.bib`: the bibliography is the site's, not
// `_lib/`'s, so it stays beside the pages that cite it and this file names it
// from the project root rather than counting directories up.
//
// No `style:`: rookery defaults to an author-date style, because citation
// numbering in Typst is document-wide and cannot be reset.
#let BIBLIOGRAPHY = arguments(bytes(read("/content/references.bib")))

// NO VERTEBRA APPLIES THIS BY HAND any more. `[spine] prelude` in `rheo.toml`
// splices `_lib/prelude.typ` into every vertebra, and it is the one
// place that writes the `#show: template` — so a new page in `content/` is a
// file with a `#set document(title: ...)` and prose, nothing else.
//
// `current-page` therefore arrives from the prelude as that vertebra's own
// `rheo-context().handle`, the one per-file field rheo injects and the one fact
// this file cannot read for itself (see `SITE-PAGES`). For a root file the
// handle IS the stem, which is what the nav's active marker compares against.
#let template(current-page: none, doc) = {
  show: rookery.with(
    theme: THEME,
    idea-page-template: idea-page,
    // `1` — the default, and what this site's own prose has always claimed
    // ("Because this documentation uses the default unfurl of `1`"). It read `0`,
    // which under the recursion semantics means NO WINDOWING ANYWHERE, so every
    // transclusion on the site rendered as a link row.
    window-unfurl: 1,
    bibliography: BIBLIOGRAPHY,
  )
  show: chrome.with(current-page: current-page)
  doc
}
