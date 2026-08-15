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

// Ids on this site read `note:<name>` rather than the default `idea:<name>`,
// and the theme replaces rookery's default light-blue/purple pair with an
// amber one. Both are ONE document-wide value: every vertebra has to ask for
// the same thing, which is another reason to set them in one file.
#let THEME = (
  link-color: "rgba(230, 140, 0, 0.16)",
  fold-color: "rgba(255, 190, 40, 0.07)",
  date-color: rgb("#a08a5a"),
)

#let template(current-page: none, doc) = {
  show: rookery.with(prefix: "note", theme: THEME)

  context if target() == "html" {
    html.elem("div", attrs: (class: "header"))[
      #image("img/header.svg")
    ]
    html.elem("hr")
  } else if target() == "paged" {
    image("img/header.svg")
  } else {}

  doc
}
