// Prepended inside every vertebra by rheo's `[spine] prelude`, after that
// page's own `rheo-context()` binding — which is what lets the `#show` below
// read the handle. rheo excludes this file from the spine itself, so it is
// spliced into pages without ever being compiled as one.
//
// ROOT-ABSOLUTE IMPORT: this text lands inside every vertebra, and a relative
// path would resolve against each page's own directory rather than against
// `content/_lib/`, where `template.typ` sits.
#import "/content/_lib/template.typ": template
// What the pages of this site actually write. The union of what they imported
// one by one before: a page that uses only `idea` is no worse off for also
// having `window` in scope, and a page that grows a second view does not have
// to edit its header to get one.
//
// `outline` IS ROOKERY'S, not Typst's, on every page of this site. That is the
// name a reader should write — `#outline(target: idea, ..)` — and the shadow
// costs nothing, since every other target proxies straight through to Typst's
// own outline unchanged.
#import "@rookery/core:0.1.0": footnote, idea, outline, window

// THE TEMPLATE, APPLIED HERE ONCE instead of at the top of every file. The
// handle is the vertebra's own — `concepts` for `content/concepts.typ` — so the
// topbar's active marker comes out right with nothing for the page to declare;
// see `template.typ`, where `SITE-PAGES` reads the other half off the spine.
#show: template.with(current-page: rheo-context().handle)
