#import "template.typ": template
#import "@rheo/rookery:0.4.0": footnote, idea, ideas-outline, note, todo, window

// `show-tags: true` by default, so every card on the page wears its kind as a
// coloured pill in the hat — the hue comes from `TAG-COLORS` in template.typ.
// Named rather than hardcoded so a call site can still turn it off.
#let concept(tags: (), show-tags: true, ..args) = idea(
  tags: (("concept",) + tags),
  show-tags: show-tags,
  ..args,
)

#show: template.with(current-page: "concepts")
#set document(
  title: "Concepts",
  date: datetime(year: 2026, month: 8, day: 20),
)

#ideas-outline()

#concept("hatching-ideas", title: [Hatching ideas])[
  Ideas are designed so that you can always hatch new ones without ceremony.
  The `#idea` function at its most basic takes the content of an idea.

  ```typ
  #import "@rheo/rookery:0.4.0": idea
  #idea[Hatch a new idea.]
  ```

  By default, an idea will inherit its date from the document in which it was hatched, and will not show it explicitly.
  If you want to keep track of when you updated individual ideas, you can explicitly set it when hatching.
  You can also give it tags to associate it with other ideas.

  ```typ
  #concept(
    // if not specified, the ID will be auto-generated
    <incremental-thought>,
    // Link text when referenced
    title: [On rookeries],
    // defaults to #document.date
    updated: datetime(year: 2026, month: 8, day: 16),
    // Whether to show when idea is hatched
    show-date: true,
    // an arbitrary list of strings
    tags: ("in-progress", "phd")
  )[
    // ...
  ]
  ```

  You can think of an idea as an #link("https://notes.andymatuschak.org/z5E5QawiXCMbtNtupvxeoEX")[evergreen note], an #link("https://www.forester-notes.org/tfmt-0007/index.xml")[atomic unit of thought], or as a generalization of the #link("https://orgmode.org/manual/TODO-Basics.html")[Orgmode TODO].
  Ideas are intentially designed as very generic units of content that can cover both these encapsulations, as well as broader containers of writing such as blog posts or journal entries.

  Rookery also provides syntactic sugar for ideas with common tags:

  ```typ
  #import "@rheo/rookery:0.4.0": todo, note
  #todo[A todo.] // #idea(..., tags: ("todo"))
  #note[A note.] // #idea(..., tags: ("note"))
  ```

  #concept("tags", title: [Tags])[
    A tag is a string you attach to an idea, and that is all it is.
    There is no fixed set and nothing is reserved or validated: an idea carrying `todo` means only that you wrote `todo` on it.
    Tags are neither a taxonomy nor a task tracker.
    They are how you say that some ideas belong together, so that later you can @idea:windows[window] on them, @idea:outlining[outline] them, or style them as a kind.

    ```typ
    #idea("meeting-notes", tags: ("draft", "review"))[...]
    ```

    Each tag becomes an `.idea-tag-<tag>` class on the idea's heading, on its box, and on its row in an outline, which is enough to style a kind of idea without ever showing the tag itself.
    The `#todo` and `#note` above are sugar over this same array, prepending their own tag to whatever you pass.

    You can ask an idea what it carries, in the order you gave them:

    ```typ
    #context tags-of("meeting-notes") // -> ("draft", "review")
    ```

    An idea that does not exist answers `()` rather than failing---a caller asking what something is tagged is filtering, not dereferencing.

    #concept(<showing-tags>, title: [Showing tags])[
      Pass `show-tags: true` and an idea's tags appear as pills in its hat, on the same short rule the ID sits on, in a fixed order: ID, then tags, then date.
      It is off by default, exactly like `show-date`.

      ```typ
      #idea("meeting-notes", tags: ("draft", "review"), show-tags: true)[...]
      #window("meeting-notes", show-tags: true) // pills here too, asked for separately
      ```

      Every idea on this site is hatched with `show-tags: true`, which is why each card wears its kind: `concept` on this page, `setup` and `reference` on the @idea:installing[reference], `faq` on the FAQ.
      An idea with no tags renders no pill, so turning it on costs nothing where there is nothing to show.
    ]

    #concept(<coloring-tags>, title: [Coloring tags])[
      A pill is grey until you say otherwise.
      `tags-color` in the @idea:theming[theme] gives a tag its own color, as a background alone or as a text-and-background pair:

      ```typ
      #show: rookery.with(theme: (
        tags-color: (
          draft: rgb("#3366ff"),                           // background
          note: (background: rgb("#0000ff"), text: white), // both
          warn: (text: rgb("#aa0000")),                    // text
        ),
      ))
      ```

      That color does not land on the pill as an inline style.
      It arrives as a rule on `.idea-tag-<tag>`, which is what lets one entry reach every surface already wearing the class: the pill, the tick an @idea:outlining[outline] row draws off its rule, and a search result's chip---which JavaScript builds in the browser, where no style Typst wrote could follow it.

      Those generated rules sit in a CSS layer, and unlayered CSS beats layered CSS whatever the source order, so a rule of your own on `.idea-tag-draft` still wins.

      Two consequences are worth knowing.
      A `tags-color` _key_ has to be usable as a CSS class, because it becomes one---a letter or an underscore, then letters, digits, hyphens and underscores.
      (An idea's own `tags:` array is unconstrained; the rule is about naming a color for a tag, not about carrying one.)
      And since a colored pill is a CSS rule, it reaches HTML alone: an EPUB ships no stylesheet, and the paged target draws no hat to put a pill in.
    ]
  ]

  #concept("footnotes", title: [Footnotes])[
    A footnote belongs to the idea in which you write it in, just as @idea:citations[citations] do.
    So that rookery can track them correctly, you need to use the `footnote` function imported from rookery in ideas, rather than the Typst native function:

    ```typ
    #import "@rheo/rookery:0.4.0": idea, footnote
    #idea("etal")[
      A claim#footnote[The evidence.] worth qualifying.
    ]
    ```

    Footnote numbering is idea-local.
    This means that there may be two footnotes labeled `1` on the same page, if two ideas with footnotes are hatched in that context.#footnote[This idea's own first footnote. The idea below has one too, also numbered 1.]

    Footnote listings occur at the end of each idea.#footnote[Ideas will show footnotes everywhere their content appears: in their hatching context, their standalone page, and their @idea:windows[windows].]
    On a standalone page, footnotes appear before the @idea:idea[context and backlinks listings].

    A footnote written outside an idea's context proxies the #link("https://typst.app/docs/reference/model/footnote/")[native Typst function] so that it behaves normally.
  ]

  #concept("citations", title: [Citations])[
    A citation belongs to the idea in which you write it, just as @idea:footnotes[footnotes] do.
    Bibliographies, like footnotes, are produced at the end of an idea.

    In contrast to footnotes, however, _all citations in a rookery draw from a global bibliography_ that is @idea:site-config[configured once] like so:

    ```typ
    #show: rookery.with(bibliography: arguments(
      bytes(read("references.bib")),
      style: "chicago-author-date",
    ))
    ```

    You must use `bytes(read(...))` rather than a path to pass a reference file, but rookery bibliographies otherwise work the same as #link("https://typst.app/docs/reference/model/bibliography/")[Typst bibliographies].

    Once a rookery is configured with a bibliography, you can cite as you naturally would in Typst @maedje2022typst.
    Bibliographies will appear at the bottom of every idea with a citation under a 'References' heading.

    Citation numbering is rookery-wide, which means that numeric styles will not be scoped to each idea.
    (An idea with one citation may show it as `[7]`, for example, if it is the 7#super[th] citation in the rookery.)
    For this reason we recommend using #link("https://typst.app/docs/reference/model/bibliography/#parameters-style")[citation styles] that don't employ numbers such as `"author-date"`.
  ]
]

#concept("referencing-ideas", title: [Referencing ideas])[
  You can reference an existing idea by creating either a *hyperlink* or a *window*.
  Both kinds of references using the idea's *ID*, which is unique in a global namespace.

  IDs are normal #link("https://typst.app/docs/reference/foundations/label/")[Typst labels], meaning that compilation will fail if there is a duplicate.
  To ensure that rookery's labels don't easily clash with ones you create yourself, the prefix `idea:` is prepended to all of your idea IDs.
  You can customize this prefix when you @idea:site-config[configure rookery].

  #concept("hyperlinks", title: [Hyperlinks])[
    Hyperlinks are the lowest-touch way to reference an idea in rookery, and are implemented as regular #link("https://typst.app/docs/reference/model/ref/")[Typst references].
    Say you have an idea:

    ```typ
    #idea("first-idea", title: [My first idea])
    ```

    The following three bullets all produce the same result: a hyperlink that reads 'My first idea' to the idea's standalone page.

    ```typ
    #import "@rheo/rookery:0.4.0": hyperlink
    - @idea:first-idea
    - @idea:first-idea[My first idea]
    - #hyperlink(<first-idea>)[My first idea]
    ```

    Note that you must use the `idea:` prefix (which @idea:referencing-ideas[you may customize]) when you are using references in the Typst namespace.
    When using the `#hyperlink` function imported from rookery, you may omit the prefix if you choose.

    If you want your references to link to the _anchor_ in the original context in which your idea was hatched, rather than the idea's standalone page, pass `link-to: "anchor"` to an individual call:

    ```typ
    - #hyperlink(<first-idea>, link-to: "anchor")[My first idea]
    ```

    If you want to redirect _all_ `@idea:x`-style references to anchors, `#hyperlink` is also `@idea:x`'s renderer, installed as a `show ref:` rule — `.with()` it instead of the default:

    ```typ
    #import "@rheo/rookery:0.4.0": hyperlink
    #show ref: hyperlink.with(link-to: "anchor")
    - @idea:first-idea // will link to anchor
    ```

    (`#set hyperlink.with(...)` does not work here — `set` rules only apply to Typst's own built-in element functions, not a plain package function like `hyperlink`.)

    Creating a hyperlink to an idea will add it to that idea's @idea:idea[set of backlinks].
  ]

  #concept("windows", title: [Windows])[
    Windows can be used to interpolate the entirety of an idea's content into a different context.
    They are useful in home pages or other sections that aggregate content.

    Fundamentally, windows are a form of augmented hyperlink.
    They take their name from Nelson's notion of the #link("https://www.xanadu.com.au/ted/TN/PARALUNE/paraviz.html")[transpointing window] as, when paired with backlinks, they allow you to see the content either side of the link.

    Say you have an idea:
    ```typ
    #idea("first-idea", title: [My first idea])
    ```

    You can produce a window on this idea like so:

    ```typ
    #import "@rheo/rookery:0.4.0": window
    #window(<first-idea>)
    ```

    Note that we do not need the `idea:` prefix.
    Like `#hyperlink`,`#window` is a function imported from rookery that already knows which namespace to look in.

    By default, this window will be unfolded, showing the full content of the idea.
    If we want it to instead be folded, we can configure it with arguments.
    We can also pass #link("https://typst.app/docs/reference/foundations/array/")[an array] of ideas to window on multiple ideas:

    ```typ
    #window(
      // filter by ids
      (<first-idea>, <second-idea>, <third-idea>),
      // only show the idea's name and id
      folded: true,
      // limit the number of lines shown in the window
      limit: 12,
      // include the document date
      show-date: true,
      // select ideas in windows using tags in addition to IDs
      // IDs and ideas matching tags compose
      tags: ("post", "docs")
    )
    ```

    Here is an example of a window on the two foundational ideas in rookery, 'rookery' and 'idea', folded and with date:

    #window((<rookery>, <idea>), folded: true, show-date: true)

    Adding a window to an idea will include the window's context in the idea's backlinks.

    An idea's @idea:footnotes[footnotes] travel with it into a window, numbered from 1 again and listed in the window's own block --- open this one and compare it with the same idea further up the page:

    #window(<footnotes>, folded: true)

    So do its @idea:citations[citations]: a window carries its own References block, resolving inside the window rather than pointing back at the idea's own page.

    #window(<citations>, folded: true)

    #concept("window-depth", title: [Window depth])[
      Windows on ideas that are _parents_ in the idea hierarchy can infinitely recurse.
      In order to prevent this, rookery has a notion of *window depth*, which is set to `1` by default.

      When a window is called at a level of recursion greater than the window depth, rookery renders a call to `#window` as a link to the idea's standalone page rather than as transcluded content.
      It's best to think of window depth as a multiplier, as the amount of work rookery needs to do multiplies when you raise it.

      You can set the window depth per window, or site-wide:
      ```typ
      #show: rookery.with(window-depth: 1)
      #window(<first-idea>)
      #window(<first-idea>, depth: 2)
      ```

      Here is a window on this selfsame idea.
      Because this documentation uses the default depth of `1`, it only recurses as a window once, and then bottoms out as a link:

      #window(<window-depth>, folded: true)
    ]
  ]
]

#concept("outlining", title: [Outlining ideas])[
  You can outline the ideas in a context like so:

  ```typ
  #import "@rheo/rookery:0.4.0": ideas-outline
  #ideas-outline()
  ```

  This outline is derived from how you nest `#idea` hatchings.
  Ideas with no title are left out (since they have no label).
  As @idea:windows[windows] are only echoes of ideas that live elsewhere, they are also not included.

  You can add a title and curtail the depth of an outline like so:

  ```typ
  #ideas-outline(title: none, depth: 2)
  ```

  Pass `rookery-wide: true` to list _every_ idea in the rookery, rather than just the current context's:

  ```typ
  #ideas-outline(title: [The whole rookery], rookery-wide: true)
  ```

  The ordering of ideas across site-wide outlines will hew to the #link("https://rheo.ohrg.org/spines")[Rheo spine's] order (which is lexicographic by filename by default), with `index.typ` first.

  Here is the outline of all ideas in this rookery:

  #ideas-outline(title: none, rookery-wide: true)
]

// #todo("searching", title: [Searching ideas])[
//   An outline lists your rookery. Searching it is a separate package,
//   `@rheo/rookery-search`, and it is worth knowing that it comes in three layers,
//   because only the top one needs Rheo.
//
//   `#ideas()` is the bottom layer, and it lives in rookery itself: every idea in
//   the rookery as plain data — its id, its title, its dates, and a link to its
//   page. Everything else is built on it, and so can anything you want to write.
//
//   `#search-ideas("query")` ranks that corpus and hands back the matches, still as
//   data. It is ordinary Typst, so it runs under plain `typst compile` with no Rheo
//   and no JavaScript at all:
//
//   ```typ
//   #import "@rheo/rookery-search:0.4.0": search-ideas
//   #context {
//     for e in search-ideas("window") [ - #link(e.href, e.text) ]
//   }
//   ```
//
//   That is a search rendered at compile time — a static list of matches, which is
//   a perfectly good answer for a printed target, or for a site that would rather
//   not ship a script.
//
//   `#search-bar()` is the top layer, and the one in the header of this page. It
//   puts the corpus on the page as JSON, adds an input, and wires the two together
//   in the browser. This is the layer that needs Rheo: its results link to the
//   standalone pages Rheo mints, and its behavior comes from a script Rheo
//   injects. Without Rheo it emits nothing, rather than a search box that could
//   never work.
//
//   ```typ
//   #import "@rheo/rookery-search:0.4.0": search-bar
//   #search-bar(placeholder: "Search ideas", limit: 12)
//   ```
//
//   Matching runs over an idea's id _and_ its title, never its body, and it is a
//   subsequence match — so `wnd` finds @idea:windows. A `-` or `_` reads as a
//   space, which is why `window-depth` is findable as "window depth" too.
//
//   If the bar is not the interface you want, you are not stuck with it. Iterate
//   `#search-ideas` in Typst and render whatever you like, or rank in the browser
//   with the same rule the bar uses, exposed there as `RheoRookerySearch.score`.
//   What you should not do is write a second ranking rule of your own: the package
//   keeps its Typst and JavaScript copies pinned to each other by a test, and a
//   third copy would drift from both.
//
//   This site is written with rookery, so this idea is in that index like any
//   other — the search box above will find it.
// ]
