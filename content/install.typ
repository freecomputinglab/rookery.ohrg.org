#import "template.typ": template
#import "@rheo/rookery:0.2.0": footnote, idea, ideas-outline

#show: template.with(current-page: "install")
#set document(
  title: "Install",
  date: datetime(year: 2026, month: 8, day: 15),
)

#ideas-outline()

#idea("installing", title: [Installing rookery])[
  The easiest way to get started with a rookery is by #link("https://rheo.ohrg.org/getting-started")[installing Rheo], a typesetting engine based on Typst.
  #footnote[If you prefer to use native Typst to compile a rookery, see @idea:using-typst]

  Once you have `rheo` on your path, you can use rookery in your Rheo project by importing it and hatching an idea:

  ```typ
  #import "@rheo/rookery:0.2.0": idea
  #idea[I want to hatch ideas with rookery.]
  ```

  That's it!
  You're now ready to hatch some ideas in a rookery.

]

#idea("configuring", title: [Configuring rookery])[
  Nothing in a rookery needs configuring before it will compile.
  There is no `ctx:` parameter to thread through your calls and no options file to fill in first, and a project that never configures anything gets the default prefix, the default theme, and every feature on this site.
  Configuration is one optional show rule, and it is the only place anything about the package can be changed.

  ```typ
  #import "@rheo/rookery:0.2.0": rookery
  #show: rookery.with(
    // IDs are now `note:etal` rather than `idea:etal`
    prefix: "note",
    // a window written inside a windowed idea unfurls one level
    window-depth: 1,
    // the accent every rookery link takes on hover
    theme: (link-color: rgb("#e68c00")),
  )
  ```

  Applying `rookery` publishes five values that hold for the whole document:

  - `prefix` (`"idea"`) --- the namespace an idea's ID lives in, which must be a non-empty string with no `:` in it, since the separator between prefix and name is added for you. See @idea:referencing-ideas[referencing ideas].
  - `window-depth` (`0`) --- how far a @idea:windows[window] written inside a windowed idea unfurls before it collapses to an ID. See @idea:window-depth[controlling window depth].
  - `theme` (`(:)`) --- the five colours the package will style for you. See @idea:theming[theming a rookery].
  - `idea-page-template` (`none`) --- your own chrome for the standalone page rookery mints per idea. See @idea:idea-pages[chrome for minted pages].
  - `bibliography` (`none`) --- Typst's own `#bibliography` arguments, for the single bibliography a rookery's @idea:citations[citations] all draw from.

  It also installs two show rules.
  The first renders `@idea:etal` as the idea it names rather than as the bare figure number Typst would otherwise give it; the second lets rookery's `#footnote` behave exactly like Typst's own when it is written outside any idea, rather than silently rendering nothing.
  Pass `refs: false` to keep everything else and skip the first of them, or `ref-target: "anchor"` to keep it but have every `@idea:etal` in the document link to the idea's @idea:hyperlinks[anchor in context] rather than to its standalone page.

  Beyond that, `rookery` sets no styles and wraps your document in nothing.
  On a document with no ideas in it, it is a no-op.#footnote[One exception, and it is load-bearing rather than cosmetic: a page that cites something outside every idea gets a `References` block after its content, because a citation that no bibliography claims fails the build.]

  Each of those five is one value for the whole document rather than one per page, and that is worth understanding before you reach for any of them.
  A Rheo project compiles its whole #link("https://rheo.ohrg.org/spines")[spine] as a single Typst document, but Typst imports are per-file, so there is no way for one page to install the show rule on behalf of the others.
  Two pages asking for different prefixes therefore do not get one each; they get whichever the spine happens to end on.
  A page that leaves the show rule out loses the reference rule, so its own `@idea:etal` renders a figure number---but it does not lose the prefix, which is what keeps a `#window` written across that boundary resolving rather than panicking on an ID nothing registered.

  The way to meet that requirement once is to wrap it in a site template that every page applies, which is what this site does.
  #link("https://github.com/breezykermo/rookery.ohrg.org/blob/main/content/template.typ")[`content/template.typ`] holds the `#show: rookery` call, the theme, the bibliography and the header nav together, and a page opens with `#show: template.with(current-page: "install")` to get all of them at once.
  It works because `show: f` inside a function body applies to the rest of that body, including the `doc` it returns, exactly as it does at the top of a file.

  #idea("theming", title: [Theming a rookery])[
    Five colours, which are the whole of what the package will style for you:

    - `link-color` --- the hover background on any rookery link, defaulting to `rgba(128, 0, 255, .12)`.
    - `fold-color` --- the hover background on a foldable @idea:windows[window] block, defaulting to `rgba(0, 100, 255, .05)`.
    - `id-color` --- the `[idea:etal]` ID's own text, defaulting to `gray`.
    - `date-color` --- an idea's or a window's date, where it is @idea:hatching-ideas[shown], also `gray`.
    - `border-color` --- the left rule that an idea, a window and an @idea:outlining[outline] all carry, falling back to `link-color`.

    The first two are the look, and the contrast between them is the point.
    Both are hover _backgrounds_, so they compare like with like: the lighter blue belongs to the fold, a block that only opens and closes, and the stronger purple to every link, which actually goes somewhere.
    (This site replaces that pair with an amber one, which is the only reason anything here looks the way it does rather than the way the package ships.)

    Values are Typst colours, or raw CSS strings where you want something Typst's colour type cannot express---`"rgba(0, 100, 255, .1)"`, `"var(--accent)"`, `"transparent"`.
    A misspelled key is a build error naming the five valid ones, rather than a colour that silently does nothing.

    Each key is also a parameter in its own right, and the granular form wins over `theme:`, so the two compose:

    ```typ
    #show: rookery.with(theme: MY-THEME, link-color: rgb("#ffd166"))
    ```

    That reads as 'my theme, but that one colour'.
    Precedence runs least specific first: the stylesheet's own default, then `theme:`, then the granular argument.
    Anything left unset at every level stays the stylesheet's default, and nothing is emitted for it at all.

    Underneath, each colour is a CSS custom property that rookery writes inline onto the elements that root a rookery subtree---an idea's box, a window, a minted page's heading---and lets inherit down to the ID and the date from there.
    The default lives inside the `var()` call, so an unconfigured rookery, and any reader whose browser does not understand custom properties, still gets the look above.
    The package emits no `<style>` element and wraps your document in nothing, which is exactly why there is no `:root` for it to hang a variable on.

    The theme is where the package's styling stops, not where yours does.
    Setting those same five properties in your own stylesheet works identically, and past them the CSS classes are the contract: `.idea`, `.idea-box`, `.idea-title`, `.idea-label`, `.idea-date`, `.idea-tag-<tag>`, `.idea-ref`, `.idea-window` and its parts, `.idea-outline`, and on a standalone page `.idea-footer`, `.idea-context` and `.idea-backlinks`.#footnote[The properties are documented at the top of the package's `src/rookery.css`, including a couple the theme deliberately does not expose---the ID's font size, and the underline colour an outbound link inside an idea takes on.]
  ]

  #idea("idea-pages", title: [Chrome for minted pages])[
    The standalone page rookery mints for each @idea:idea[idea] is a separate document, spliced in at the root of the bundle and outside every page of your own, so it inherits nothing from the show rules your project applies to those.
    Left alone it is bare: the idea's title and ID, its body, and the context and backlinks footer, with no site header and no nav.
    `idea-page-template` is how you hand one over.

    ```typ
    // One named, top-level function...
    #let idea-page(id: none, note: (:), doc) = {
      show: chrome.with(current-page: id)
      doc
    }

    // ...registered once, in the template every page applies.
    #show: rookery.with(idea-page-template: idea-page)
    ```

    It is called once per idea and wraps the whole minted page---heading, body and footer---so it sees exactly what a page's own show rule would.
    `id` is the idea's full ID, the same string `#window` and `@idea:etal` name it by, and so the natural answer to the question of which page you are on.
    `note` is the idea's registry record---its `title`, its `minted` and `updated` dates, the `origin` handle of the page it was hatched in, and its outbound `links`---so a richer header needs no query of your own.

    Two things to get right.
    Make it a named top-level binding rather than a closure written inline in the template that registers it: the package holds it on a document-wide state, and a fresh closure per page puts a different value on that state's timeline for each one, where a named binding is one value however many pages reference it.
    And apply your _chrome_ from it rather than your whole page template, splitting that chrome out of the template if you have not already---otherwise the two have to reference each other.
    A minted page has no need to re-apply `#show: rookery`, since every page of your own has already published the prefix, the theme and the rest by the time one is minted.

    Every `[idea:...]` ID on this site is a link to one of these pages, and they carry this site's header because it hands rookery an `idea-page-template` of exactly the shape above.
  ]
]
