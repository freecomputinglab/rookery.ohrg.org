// `display-tags: true` by default, so every card on the page wears its kind as a
// coloured pill in the hat — the hue comes from `TAG-COLORS` in `_lib/template.typ`.
// Named rather than hardcoded so a call site can still turn it off.
#let concept(tags: (), display-tags: true, ..args) = idea(
  tags: (("concept",) + tags),
  display-tags: display-tags,
  ..args,
)

#set document(
  title: "Rookery - Concepts",
  date: datetime(year: 2026, month: 8, day: 20),
)

#outline(target: idea, scope: "page")

#concept("hatching-ideas", title: [Hatching ideas])[
  Ideas are designed so that you can always hatch new ones without ceremony.
  The `#idea` function at its most basic takes the content of an idea.

  ```typ
  #idea[Hatch a new idea.]
  ```

  You can think of an idea as an #link("https://notes.andymatuschak.org/z5E5QawiXCMbtNtupvxeoEX")[evergreen note], an #link("https://www.forester-notes.org/tfmt-0007/index.xml")[atomic unit of thought], as a generalization of the #link("https://orgmode.org/manual/TODO-Basics.html")[Orgmode TODO], or simply as a referenceable and taggable block of content.
  All ideas in your rookery are conceptually networked together so that you can treat a rookery as an #link("https://www.ohrg.org/devonthink-part-i.html")[associative archive].

  An idea might be a short note you want to jot down, a record relating to person or a place, a blog post, an academic paper, a @idea:rookery-todos[todo item], a @idea:rookery-meetings[meeting note], a note associated to a @idea:rookery-bibtex[citation], a tracking issue for a @idea:rookery-cfps[call for proposals], or any other kind of structured content fragment you can imagine.
  You can specify custom metadata structures for certain types of ideas using @idea:tags[tags].

  - @idea:idea-reference[Reference documentation for `#idea`].

  #concept("ideating", title: [Ideating])[
    When you sit down at your computer, ready to jot down some ideas or write a piece, it wouldn't be nice to have to always explicitly wrap your content in `#idea` blocks.
    You can use the `#ideate` function in combination with a Typst `#show` rule to _implicitly_ parcel your writing into ideas:

    ```typ
    #import "@rookery/core": ideate
    #show: ideate

    = Let's get rolling
    Straight into it without ceremony.
    ```

    This will wrap your writing as an idea, taking the `#document.title` as its name.
    Importantly, you can parameterize the `#ideate` function to parcel your writing out into ideas differently:

    ```typ
    #show: ideate.with(separator: heading.where(level: 2))

    == First idea
    The body of my first idea.

    == Second idea
    The body of my second idea.
    ```

    This is useful when you want to take writing in Typst that isn't structured as ideas and import them into a rookery, as you don't have to retrofit `#idea` blocks throughout: you just need to design the right `#ideate` show rule.
    Ideation also works nicely with #link("https://rheo.ohrg.org/spines")[Rheo spines], as it means that you organize your ideas using files and folders and still have them appear in the flat idea space so that they can be further organized using @idea:tags[tags].

    - @idea:ideate-reference[Reference documentation for `#ideate`].
  ]

  #concept("tags", title: [Tags])[
    You can add tags to any idea.
    Tags work as a lateral filter across many ideas that you can use to group @idea:windows[windows] on them, group @idea:outlines[outlines], or filter ideas in a @idea:rookery-search[search modal].

    ```typ
    #idea(
      "meeting-notes",
      tags: ("draft", "review"),
    )[ ... ]

    /* Window over all ideas with the tag "draft" */
    #window(tagged: "draft")
    ```

    Beneath their appearance as simple strings that can be used to organize ideas, tags are implemented as hash maps using strings as keys and abstract types as values.
    This means that you can use them to build up complex data structures that function as metadata for more structured ideas:

    ```typ
    #idea(
      title: [An idea with complex metadata],
      tags: (
        "opened": datetime(year: 2026, month: 9, day: 19),
        "expected-length": duration(days: 2, hours: 1, minutes: 30),
        "details": ("a": 1, "b": 2),
      ),
    )
    ```

    For an example of treating tags as metadata to create more structured idea variants, see @idea:rookery-timeline.
  ]

  #concept("footnotes", title: [Footnotes])[
    A footnote belongs to the idea in which you write it in, just as @idea:citations[citations] do.
    So that rookery can track them correctly, you need to use the `footnote` function imported from rookery in ideas, rather than the Typst native function:

    ```typ
    #import "@rookery/core:0.1.0": idea, footnote
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
  Both kinds of references use the idea's *name*, which is unique in a global namespace.

  Names are normal #link("https://typst.app/docs/reference/foundations/label/")[Typst labels], meaning that compilation will fail if there is a duplicate.
  To ensure that rookery's labels don't easily clash with ones you create yourself, the prefix `idea:` is prepended to all of your idea names.
  You can customize this prefix when you @idea:site-config[configure rookery].

  #concept("hyperlinks", title: [Hyperlinks])[
    Hyperlinks are the lowest-touch way to reference an idea in rookery, and are implemented as regular #link("https://typst.app/docs/reference/model/ref/")[Typst references].
    Say you have an idea:

    ```typ
    #idea("first-idea", title: [My first idea])
    ```

    The following three bullets all produce the same result: a hyperlink that reads 'My first idea' to the idea's standalone page.

    #concept("standalone-idea-pages", title: [Standalone pages for ideas])[
      When you compile a rookery with #link("https://rheo.ohrg.org")[Rheo], each idea that you declare will produce its own standalone page.
      When you link to an idea using a @idea:hyperlinks[hyperlink], by default it will link that that idea's standalone page.
      (To link to the page in which the idea was actually declared, see @idea:hyperlink-reference.).

      The slug for the standalone page will be `/ideas/<idea-name>`, where `<idea-name>` is the name you give or the @idea:auto-naming[one that is generated] for it.
    ]

    ```typ
    #import "@rookery/core:0.1.0": hyperlink
    - @idea:first-idea
    - @idea:first-idea[My first idea]
    - #hyperlink(<first-idea>)[My first idea]
    ```

    Note that you must use the `idea:` prefix (which @idea:referencing-ideas[you may customize]) when you are using references in the Typst namespace.
    When using the `#hyperlink` function imported from rookery, you may omit the prefix if you choose.

    Creating a hyperlink to an idea will add it to that idea's @idea:idea[set of backlinks].

    - @idea:hyperlink-reference[Reference documentation for `#hyperlink`].
  ]

  #concept("windows", title: [Windows])[
    Windows can be used to interpolate the entirety of an idea's content into a different context.
    They are useful in home pages or other sections that aggregate content.

    Fundamentally, windows are a form of augmented hyperlink.
    They take their name from Ted Nelson's notion of the #link("https://www.xanadu.com.au/ted/TN/PARALUNE/paraviz.html")[transpointing window] as they allow you to see the content either side of the link (like a window).

    Say you have an idea:
    ```typ
    #idea("first-idea", title: [My first idea])
    ```

    You can produce a window on this idea like so:

    ```typ
    #import "@rookery/core:0.1.0": window
    #window(<first-idea>)
    ```

    Note that we do not need the `idea:` prefix.
    Like `#hyperlink`,`#window` is a function imported from rookery that already knows which namespace to look in.

    By default, this window will be unfolded, showing the full content of the idea.

    - @idea:window-reference[Reference documentation for `#window`].

    #concept("window-depth", title: [Unfurling windows])[
      Windows on ideas that are _parents_ in the idea hierarchy can infinitely recurse.
      In order to prevent this, rookery has a notion of *window unfurl*, which is set to `1` by default.

      When a window is called at a level of recursion greater than the unfurl budget, rookery renders a call to `#window` as a link to the idea's standalone page rather than as transcluded content.
      It's best to think of window unfurl as a multiplier, as the amount of work rookery needs to do multiplies when you raise it.

      You can set the unfurl budget per window, or site-wide:
      ```typ
      #show: rookery.with(window-unfurl: 1)
      #window(<first-idea>)
      #window(<first-idea>, unfurl: 2)
      ```

      Here is a window on this selfsame idea.
      Because this documentation uses the default unfurl of `1`, it only recurses as a window once, and then bottoms out as a link:

      #window(<window-depth>, folded: true)
    ]
  ]

  #concept("outlines", title: [Outlines])[
    You can outline the ideas in a context like so:

    ```typ
    #import "@rookery/core:0.1.0": idea, outline
    #outline(target: idea)
    ```

    Typst's own way of outlining something other than headings is to name it with `target:`, so rookery overloads that call rather than asking you to learn a second one.
    `target: idea` outlines your ideas; every other target---the default `heading`, a figure kind, anything else---passes straight through to Typst's `#outline` unchanged.

    This outline is derived from how you nest `#idea` hatchings, and lists every idea in the rookery by default---pass `scope: "page"` to narrow it to only the ideas written on this page.
    As @idea:windows[windows] are only echoes of ideas that live elsewhere, they are also not included.

    - @idea:outline-reference[Reference documentation for `#outline`].

    The ordering of ideas across site-wide outlines will hew to the #link("https://rheo.ohrg.org/spines")[Rheo spine's] order (which is lexicographic by filename by default), with `index.typ` first.

  ]

  #concept("auto-naming", title: [How are ideas auto-named?])[
    When you declare an idea without a name, rookery will generate one for you.
    Because a compiled rookery is a pure function of the files that are on disk, however, _auto-names may drift as you move and edit the idea_.

    Rookery will make a best effort to give your idea a unique name through the following heuristic:
    1. Use a kebab-case version of the idea's title.
    2. For ideas without a title, construct a name from recombining and hashing the body content.

    This heuristic is not guaranteed to produce unique names for all ideas.
    When you have two ideas without a title and the same body content, for example, the auto-name for both ideas will be identical.
    _When two or more ideas have the same name, your rookery's compilation will fail_.

    Due to the lack of a uniqueness guarantee and the instability of auto-naming, *we recommend explicitly naming all ideas in your rookery*.
    If you don't care about choosing your ideas' names, you can consider simply copying the auto-name from the browser and pasting it into Typst.
    Auto-naming exists so that inventing a name for each idea does not gate its inclusion in the rookery, but it should be treated as a provisional band-aid rather than a load-bearing mechanism.


  ]
]


