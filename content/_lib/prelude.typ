// rheo's `[spine] prelude` prepends this file inside every vertebra, after that
// page's own `rheo-context()` binding, which is what lets the `#show` below read
// the handle.
//
// The import is root-absolute because this text lands inside every vertebra: a
// relative path would resolve against each page's directory rather than against
// `content/_lib/`.
#import "/content/_lib/template.typ": template
// What the pages of this site write. A page that uses only `idea` is no worse
// off for having `window` in scope, and a page that grows a second view does not
// have to edit its header to get one.
//
// The `outline` here is rookery's, not Typst's. That is the name a reader should
// write, and the shadow costs nothing: every target other than `idea` proxies
// straight through to Typst's own outline.
#import "@rookery/core:0.1.0": footnote, idea, outline, window

// The template, applied once here instead of at the top of every file. The
// handle is the vertebra's own — `concepts` for `content/concepts.typ` — so the
// topbar's active marker comes out right with nothing for the page to declare.
#show: template.with(current-page: rheo-context().handle)
