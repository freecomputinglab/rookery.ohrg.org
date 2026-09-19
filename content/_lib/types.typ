// The Typst type names an argument table cites, each linked to its own page in
// the Typst docs. Here rather than at the top of `content/reference.typ`, which
// is the page that cites them today, because any page documenting an argument
// list of its own wants the same twelve links, and a second copy of this list
// would drift from the first.
//
// `_lib/` is excluded from the spine (`rheo.toml`), so this file is machinery
// rather than a page: it is imported, never compiled as a vertebra.
#let type-string = link("https://typst.app/docs/reference/foundations/str/")[str]
#let type-label = link("https://typst.app/docs/reference/foundations/label/")[label]
#let type-content = link("https://typst.app/docs/reference/foundations/content/")[content]
#let type-int = link("https://typst.app/docs/reference/foundations/int/")[int]
#let type-bool = link("https://typst.app/docs/reference/foundations/bool/")[bool]
#let type-array = link("https://typst.app/docs/reference/foundations/array/")[array]
#let type-dict = link("https://typst.app/docs/reference/foundations/dictionary/")[dictionary]
#let type-datetime = link("https://typst.app/docs/reference/foundations/datetime/")[datetime]
#let type-auto = link("https://typst.app/docs/reference/foundations/auto/")[auto]
#let type-none = link("https://typst.app/docs/reference/foundations/none/")[none]
#let type-function = link("https://typst.app/docs/reference/foundations/function/")[function]
