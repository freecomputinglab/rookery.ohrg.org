#import "template.typ": template
#import "@rheo/rookery:0.1.1": footnote, idea, ideas-outline, note, todo, window

#show: template.with(current-page: "concepts")
#set document(
  title: "Concepts",
  date: datetime(year: 2026, month: 8, day: 15),
)

#ideas-outline()

#idea("hatching-ideas", title: [Hatching ideas])[
  Ideas are designed so that you can always hatch new ones without ceremony.
  The `#idea` function at its most basic takes the content of an idea.

  ```typ
  #import "@rheo/rookery:0.1.1": idea
  #idea[Hatch a new idea.]
  ```

  By default, an idea will inherit its date from the document in which it was hatched, and will not show it explicitly.
  If you want to keep track of when you updated individual ideas, you can explicitly set it when hatching.
  You can also give it tags to associate it with other ideas.

  ```typ
  #idea(
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
  #import "@rheo/rookery:0.1.1": todo, note
  #todo[A todo.] // #idea(..., tags: ("todo"))
  #note[A note.] // #idea(..., tags: ("note"))
  ```

  #idea("footnotes", title: [Footnotes])[
    A footnote belongs to the idea in which you write it in, just as @idea:citations[citations] do.
    So that rookery can track them correctly, you need to use the `footnote` function imported from rookery in ideas, rather than the Typst native function:

    ```typ
    #import "@rheo/rookery:0.1.1": idea, footnote
    #idea("etal")[
      A claim#footnote[The evidence.] worth qualifying.
    ]
    ```

    Footnote numbering is idea-local.
    This means that there may be two footnotes labelled `1` on the same page, if two ideas with footnotes are hatched in that context.#footnote[This idea's own first footnote. The idea below has one too, also numbered 1.]

    Footnote listings occur at the end of each idea.#footnote[Ideas will show footnotes everywhere their content appears: in their hatching context, their standalone page, and their @idea:windows[windows].A footnote reference is a same-page link, so a window on another page needs its target on that page.]
    On a standalone page, footnotes appear before the @idea:idea[context and backlinks listings].

    A footnote written outside an idea's context proxies the #link("https://typst.app/docs/reference/model/footnote/")[native Typst function] so that it behaves normally.
  ]

  #idea("citations", title: [Citations])[
    A citation belongs to the idea in which you write it, just as @idea:footnotes[footnotes] do.
    Bibliographies, like footnotes, are produced at the end of an idea.

    In contrast to footnotes, however, _all citations in a rookery draw from a global bibliography_ that is @idea:configuring[configured once] like so:

    ```typ
    #show: rookery.with(bibliography: arguments(
      bytes(read("references.bib")),
      style: "chicago-author-date",
    ))
    ```

    You must use `bytes(read(...))` rather than a path to pass a reference file, but rookery bibliographies otherwise work the same as #link("https://typst.app/docs/reference/model/bibliography/")[Typst bibliographies].

    Once a rookery is configured with a bibliography, you can cite as you naturally would in Typst @maedje2022typst.

    Citation numbering is rookery-wide, which means that numeric styles will not be scoped to each idea.
    (An idea with one citation may show it as `[7]`, for example, if it is the 7#super[th] citation in the rookery.)
    For this reason we recommend using #link("https://typst.app/docs/reference/model/bibliography/#parameters-style")[citation styles] that don't employ numbers such as `"author-date"`.
  ]
]

#idea("referencing-ideas", title: [Referencing ideas])[
  You can reference an existing idea by creating either a *hyperlink* or a *window*.
  Both kinds of references using the idea's *ID*, which is unique in a global namespace.

  IDs are normal #link("https://typst.app/docs/reference/foundations/label/")[Typst labels], meaning that compilation will fail if there is a duplicate.
  To ensure that rookery's labels don't easily clash with ones you create yourself, the prefix `idea:` is prepended to all of your idea IDs.
  You can customize this prefix when you @idea:configuring[configure rookery].

  #idea("hyperlinks", title: [Hyperlinks])[
    Hyperlinks are the lowest-touch way to reference an idea in rookery, and are implemented as regular #link("https://typst.app/docs/reference/model/ref/")[Typst references].
    Say you have an idea:

    ```typ
    #idea("first-idea", title: [My first idea])
    ```

    The following three bullets all produce the same result: a hyperlink that reads 'My first idea' to the idea's standalone page.

    ```typ
    #import "@rheo/rookery:0.1.1": hyperlink
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
    #import "@rheo/rookery:0.1.1": hyperlink
    #show ref: hyperlink.with(link-to: "anchor")
    - @idea:first-idea // will link to anchor
    ```

    (`#set hyperlink.with(...)` does not work here — `set` rules only apply to Typst's own built-in element functions, not a plain package function like `hyperlink`.)

    Creating a hyperlink to an idea will add it to that idea's @idea:idea[set of backlinks].
  ]

  #idea("windows", title: [Windows])[
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
    #import "@rheo/rookery:0.1.1": window
    #window(<first-idea>)
    ```


    Note that we do not need the `idea:` prefix.
    Like `#hyperlink`,`#window` is a function imported from rookery that already knows which namespace to look in.

    By default, this window will be unfolded, showing the full content of the idea.
    If we want it to instead be folded, we can configure it with arguments.
    We can also pass #link("https://typst.app/docs/reference/foundations/array/")[an array] of ideas to window on multiple ideas:

    ```typ
    #window(
      (<first-idea>, <second-idea>, <third-idea>),
      // only show the idea's name and id
      folded: true,
      // limit the number of lines shown in the window
      limit: 12,
      // include the document date
      show-date: true,
    )
    ```

    Here is an example of a window on the two foundational ideas in rookery, 'rookery' and 'idea', folded and with date:

    #window((<rookery>, <idea>), folded: true, show-date: true)

    Adding a window to an idea will include the window's context in the idea's backlinks.

    An idea's @idea:footnotes[footnotes] travel with it into a window, numbered from 1 again and listed in the window's own block --- open this one and compare it with the same idea further up the page:

    #window(<footnotes>, folded: true)

    So do its @idea:citations[citations]: a window carries its own References block, resolving inside the window rather than pointing back at the idea's own page.

    #window(<citations>, folded: true)

    #idea("window-depth", title: [Controlling window depth])[
      Windows on ideas that are parents in the idea hierarchy can infinitely recurse.
      By default they do not: a window written inside an idea you are windowing on collapses to its ID, so you always see one idea rather than a tree of them.

      Raise `depth` to unfurl those inner windows, one level per count:

      ```typ
      #window(<first-idea>, depth: 1)
      ```

      You can configure window depth rookery-wide like so:

      ```typ
      #show: rookery.with(window-depth: 1)
      #window(<first-idea>)
      #window(<second-idea>, depth: 0)
      ```

      The count is a budget, and it is what makes this safe to ask for.
      An idea that windows on itself, or two that window on each other, would otherwise unfurl forever; with a budget they bottom out at the ID and stop.
      Each level also re-renders the idea's body, so the work multiplies rather than adds --- keep the numbers small.

      Here is a window on this idea's own parent, at the default depth.
      Its own windows show only as ID links:

      #window(<windows>, folded: true)
    ]
  ]
]

#idea("outlining", title: [Outlining ideas])[
  You can outline the ideas in a context like so:

  ```typ
  #import "@rheo/rookery:0.1.1": ideas-outline
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

#idea("searching", title: [Searching ideas])[
  An outline lists your rookery. Searching it is a separate package,
  `@rheo/rookery-search`, and it is worth knowing that it comes in three layers,
  because only the top one needs Rheo.

  `#ideas()` is the bottom layer, and it lives in rookery itself: every idea in
  the rookery as plain data — its id, its title, its dates, and a link to its
  page. Everything else is built on it, and so can anything you want to write.

  `#search-ideas("query")` ranks that corpus and hands back the matches, still as
  data. It is ordinary Typst, so it runs under plain `typst compile` with no Rheo
  and no JavaScript at all:

  ```typ
  #import "@rheo/rookery-search:0.1.0": search-ideas
  #context {
    for e in search-ideas("window") [ - #link(e.href, e.text) ]
  }
  ```

  That is a search rendered at compile time — a static list of matches, which is
  a perfectly good answer for a printed target, or for a site that would rather
  not ship a script.

  `#search-bar()` is the top layer, and the one in the header of this page. It
  puts the corpus on the page as JSON, adds an input, and wires the two together
  in the browser. This is the layer that needs Rheo: its results link to the
  standalone pages Rheo mints, and its behaviour comes from a script Rheo
  injects. Without Rheo it emits nothing, rather than a search box that could
  never work.

  ```typ
  #import "@rheo/rookery-search:0.1.0": search-bar
  #search-bar(placeholder: "Search ideas", limit: 12)
  ```

  Matching runs over an idea's id _and_ its title, never its body, and it is a
  subsequence match — so `wnd` finds @idea:windows. A `-` or `_` reads as a
  space, which is why `window-depth` is findable as "window depth" too.

  If the bar is not the interface you want, you are not stuck with it. Iterate
  `#search-ideas` in Typst and render whatever you like, or rank in the browser
  with the same rule the bar uses, exposed there as `RheoRookerySearch.score`.
  What you should not do is write a second ranking rule of your own: the package
  keeps its Typst and JavaScript copies pinned to each other by a test, and a
  third copy would drift from both.

  This site is written with rookery, so this idea is in that index like any
  other — the search box above will find it.
]
