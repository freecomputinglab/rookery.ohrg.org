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
  title: "Rookery - Concepts",
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
    You can add tags to any idea.
    Tags work as a lateral filter across many ideas that you can use to group @idea:windows[windows] on them, group @idea:outlining[outlines], or otherwise organize them.

    ```typ
    #idea(
      "meeting-notes",
      tags: ("draft", "review"),
    )[ ... ]
    ```

    When creating new @idea:idea[ideas] or @idea:windows[windows], you can set `show-tags: true` to demonstrate

    ```typ
    #window(
      "meeting-notes",
      show-tags: true,
    )
    ```

    This will render pills next to the idea's ID, just like you see above.
    The colors associated with each tag can be configured in @idea:theme-reference[your rookery's theme].

    You can also work backwards, getting tags from an idea:

    ```typ
    #context tags-of("meeting-notes") // -> ("draft", "review")
    ```
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

    What you write _inside_ a footnote belongs to the idea as well, and not to the footnote.
    A @idea:citations[citation] in a footnote is claimed by the surrounding idea and listed in its References,#footnote[As this one is @maedje2022typst. Look for it in this idea's References block below, rather than in the footnote itself.] and a @idea:windows[window] or an `@idea:` reference in a footnote registers its backlink exactly as it would in the idea's own prose.
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
    They take their name from Nelson's notion of the #link("https://www.xanadu.com.au/ted/TN/PARALUNE/paraviz.html")[transpointing window] as they allow you to see the content either side of the link (like a window).

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
      // the ideas to window on
      (<first-idea>, <second-idea>, <third-idea>),
      // only show each idea's title and ID
      folded: true,
      // truncate each body to its first 12 blocks
      limit: 12,
      // how to order the matching ideas in the window
      // one of "auto", "date", or "lexicographic"
      sort: "date", // "auto" by default, i.e. in order of specification
      // show the idea's date in the hat
      show-date: true,
      // and its tags, as pills
      show-tags: true,
      // select ideas with one of the following tags
      tags: ("concept", "reference"),
      // whether tags should ALL be required, or only ANY one of them
      match: "all" // "any" by default
    )
    ```
  ]

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

#concept("outlining", title: [Outlining ideas])[
  You can outline the ideas in a context like so:

  ```typ
  #import "@rheo/rookery:0.4.0": ideas-outline
  #ideas-outline()
  ```

  This outline is derived from how you nest `#idea` hatchings.
  Ideas with no title are left out (since they have no label).
  As @idea:windows[windows] are only echoes of ideas that live elsewhere, they are also not included.

  You can add a title and configure the outline:

  ```typ
  #ideas-outline(
    title: [The whole rookery],
    // only show ideas this many levels deep
    depth: 2,
    // limit ideas shown to those with one of these tags
    tags: ("todo", "note"),
    // customize the way ideas are filtered
    filter: t => "todo" in t and "done" not in t,
    // list every idea in the rookery
    rookery-wide: true,
  )
  ```

  The ordering of ideas across site-wide outlines will hew to the #link("https://rheo.ohrg.org/spines")[Rheo spine's] order (which is lexicographic by filename by default), with `index.typ` first.
  Here is the outline of all ideas in this rookery:

  #ideas-outline(title: none, rookery-wide: true)
]
