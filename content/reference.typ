#import "template.typ": template
#import "@rookery/core:0.1.0": footnote, idea, ideas-outline

#show: template.with(current-page: "reference")
#set document(
  title: "Rookery - Reference",
  date: datetime(year: 2026, month: 8, day: 20),
)

// The two kinds of idea this page hatches, wrapped the way `concepts.typ` and
// `faq.typ` wrap theirs: the tag is the page's own vocabulary rather than
// something a call site should have to remember, and `show-tags: true` puts it
// in the hat as a coloured pill (hues in `TAG-COLORS`, template.typ). Setup is
// a step you follow once; reference is a table you come back to.
#let setup(tags: (), show-tags: true, ..args) = idea(
  tags: (("setup",) + tags),
  show-tags: show-tags,
  ..args,
)

#let reference(tags: (), show-tags: true, ..args) = idea(
  tags: (("reference",) + tags),
  show-tags: show-tags,
  ..args,
)

#ideas-outline()

#setup("installing", title: [Installing rookery])[
  The easiest way to get started with a rookery is by #link("https://rheo.ohrg.org/getting-started")[installing Rheo], a typesetting engine based on Typst.
  #footnote[If you prefer to use native Typst to compile a rookery, see @idea:using-typst]

  Once you have `rheo` on your path, you can use rookery in your Rheo project by importing it and hatching an idea:

  ```typ
  #import "@rookery/core:0.1.0": idea
  #idea[I want to hatch ideas with rookery.]
  ```

  That's it!

  Your rookery is now ready to nurture your every next idea.
]

== Configuration

#setup(<site-config>, title: [Site-wide configuration])[
  You can configure your rookery by calling a show rule after you import it.

  ```typ
  #import "@rookery/core:0.1.0": rookery
  #show: rookery.with(
    // IDs are now `note:etal` rather than `idea:etal`
    prefix: "note",
    // a window written inside a windowed idea unfurls one level
    window-depth: 1,
    // the accent every rookery link takes on hover
    theme: (link-color: rgb("#e68c00")),
  )
  ```

  We suggest that you wrap this configuration in a template function that fronts every page:

  ```typ
  // template.typ
  #import "@rookery/core:0.1.0": rookery
  #let template(doc) = {
    show: rookery.with(
      theme: THEME,
      idea-page-template: idea-page,
      window-depth: 1,
      bibliography: BIBLIOGRAPHY,
    )
    doc
  }

  // ...
  // at the start of each file
  #
  #import "template.typ": template
  #show: template
  ```

  #reference(<config-reference>, title: [Argument reference])[
    #table(
      columns: (auto, auto, 1fr),
      table.header([Parameter], [Default], [What it sets]),

      [`prefix`],
      [`"idea"`],
      [The namespace an idea's ID lives in; non-empty, no `:` (the separator is added for you). See @idea:referencing-ideas[referencing ideas].],

      [`window-depth`],
      [`0`],
      [How many levels of transclusion are allowed before a @idea:windows[window] bottoms out as a link to the idea's own page. `0` allows none. See @idea:window-depth[controlling window depth].],

      [`theme`],
      [`(:)`],
      [The five colors the package will style for you; each key is also a parameter in its own right, and the granular form wins. See @idea:theming[theming a rookery].],

      [`idea-page-template`],
      [`none`],
      [Your own chrome for the standalone page rookery mints per idea. See @idea:idea-template[idea template].],

      [`bibliography`],
      [`none`],
      [Typst's own `#bibliography` arguments, for the single bibliography a rookery's @idea:citations[citations] all draw from.],

      [`index-page`],
      [`true`],
      [Whether to mint `ideas/index.html`, a landing page listing every idea in the rookery. Set it to `false` where your site already publishes an index of its own.],

      [`refs`],
      [`true`],
      [Whether rookery installs the `show ref:` rule that renders `@idea:etal` as the idea rather than a figure number. Set it to `false` to keep Typst's own behaviour, or to install a rule of your own. See @idea:hyperlinks[hyperlinks].],

      [`ref-target`],
      [`"page"`],
      [Where every `@idea:etal` in the document lands: `"page"` on the idea's standalone page, `"anchor"` in the context it was hatched in. Ignored when `refs` is `false`. See @idea:hyperlinks[hyperlinks].],

      [`syndicate`],
      [`false`],
      [Whether each minted page also carries an `<rssfeed:item>` beacon, so a feed package can collect your ideas without either package importing the other. Off by default: a package should not write into another's label namespace unasked. An idea with no date never gets one.],
    )
  ]

  #reference(<theming>, title: [Theming a rookery])[
    You can theme rookery using a show rule:

    ```typ
    #import "@rookery/core:0.1.0": rookery
    #show: rookery.with(
      theme: (
        // the accent every rookery link takes on hover
        link-color: rgb("#e68c00"),
        // the quieter hover a foldable window gets
        fold-color: "rgba(230, 140, 0, .05)",
        // the left rule, where it should not follow `link-color`
        border-color: rgb("#3d3d3d"),
      ),
    )
    ```

    Each key can also be passed as a parameter directly to the `rookery` function, with will take precedence over the `theme` dictionary:

    ```typ
    #show: rookery.with(
      theme: MY-THEME,
      link-color: rgb("#ffd166"),
    )
    ```

    Every value is either a Typst color or a raw CSS string.
    Rookery allows a string so that you can specify `rgba(...)`, `color-mix(...)`, `var(--your-own)` and anything else CSS accepts valid.

    #reference(<theme-reference>, title: [Theme reference])[
      #table(
        columns: (auto, auto, 1fr),
        table.header([Key], [Default], [What it sets]),

        [`link-color`],
        [`rgba(128, 0, 255, .12)`],
        [The hover background on any rookery link, and the fallback `border-color` takes when you leave it unset.],

        [`fold-color`], [`rgba(0, 100, 255, .05)`], [The hover background on a foldable @idea:windows[window] block.],

        [`id-color`], [`gray`], [The `[idea:etal]` ID's own text.],

        [`date-color`], [`gray`], [An idea's or a window's date, where it is @idea:hatching-ideas[shown].],

        [`border-color`],
        [`link-color`],
        [The left rule that an idea, a window and an @idea:outlining[outline] all carry.],

        [`rule-width`],
        [`2px`],
        [How thick that rule is. The card's corner is arithmetic against it, so the tab the ID straddles stays shut when you move it.],

        [`pad`],
        [`0.5em`],
        [The padding every rookery block measures from---an idea's box, a window's, and the indent a nested one takes.],

        [`label-font`],
        [`monospace`],
        [The face the `[idea:etal]` ID is set in, and the outline's 'Contents' title with it. Both are machinery rather than writing, so both leave the prose face behind.],

        [`label-size`],
        [`0.57rem`],
        [The size of that ID. Load-bearing beyond the label: the tab's lift, a window's summary and the footer's padding are all measured against it, so the corner closes at whatever size you choose. `rem` rather than `em`, so it does not shrink again inside a window.],

        [`tags-color`],
        [`(:)`],
        [One color, or a `(text:, background:)` pair, per tag---delivered as a rule on `.idea-tag-<tag>` so it reaches the pill, the outline row's marker and a search result's chip alike.],
      )
    ]

    #reference(<class-reference>, title: [HTML class reference])[

      You can also style more granularly with your own CSS using the classes below.
      A trailing `*` below stands for a family whose members are named in the description.

      #table(
        columns: (auto, 1fr),
        table.header([Class], [What it is]),

        [`.idea-box`],
        [An idea's own block where it was written, carrying the left rule and the padding every rookery block nested inside it measures from.],

        [`.idea-head`, `.idea-tab`], [The heading group, and the short top rule the ID straddles at the card's corner.],

        [`.idea`, `.idea-title`],
        [The idea's heading element---which carries the anchor an `@idea:etal` fragment resolves to---and the title text inside it.],

        [`.idea-label`, `.idea-date`],
        [The `[idea:etal]` permalink and the date beside it, in a heading, a window summary or prose, wherever either is @idea:hatching-ideas[shown].],

        [`.idea-tag`, `.idea-tag-<tag>`],
        [A tag pill in the hat, and one extra class per tag the idea carries. The second reaches every surface that names the tag---the idea's heading, its box, its outline row, its pill, and a search result's chip, which JavaScript builds in the browser---so a single rule of your own styles a tag everywhere it shows up.],

        [`.idea-ref`], [An `@idea:other` reference in prose. See @idea:referencing-ideas[referencing ideas].],

        [`.idea-window`],
        [A @idea:windows[transclusion], wearing the same rule and indent as `.idea-box`; the second class `.idea-window-plain` opts a bare `#idea-body` out of that box.],

        [`.idea-window-*`],
        [The fold: `-details` the `<details>`, `-summary` the row you click, `-title` and `-date` the two things in that row, `-body` what folds away under it.],

        [`.idea-outline*`],
        [A page's @idea:outlining[outline]: `.idea-outline` the list at each level of nesting, `-title` its "Contents" label, `-row` one row per idea.],

        [`.idea-footnote*`],
        [An idea's own @idea:footnotes[footnotes], carried on every surface it appears on: `.idea-footnotes` the block, `-title` its label, `.idea-footnote-list` and `.idea-footnote` its entries.],

        [`.idea-fn-*`], [`-ref` the superscript mark in prose, `-backlink` the way back up to it from the entry.],

        [`.idea-references`, `.idea-page-refs`],
        [The bibliography an idea's @idea:citations[citations] draw from, and the page's own for citations written outside any idea.],

        [`.idea-footer*`],
        [On an @idea:idea-template[idea page]: `.idea-footer` the ruled-off apparatus under the note, `-title` the label on each of its sections.],

        [`.idea-context`, `.idea-backlinks`],
        [That footer's two sections: where the note was written, and the notes pointing at it.],

        [`.idea-page-list`, `.idea-page-row`],
        [A list of pages in either section, and one row in it---a page cannot fold, so it wears a window's shape without being one.],
      )
    ]

    #reference(<css-reference>, title: [CSS variable reference])[
      You can override any value from the @idea:theme-reference[theme reference] as a CSS variable, as well as other aspects of a rookery's appearance.

      #table(
        columns: (auto, auto, 1fr),
        table.header([Property], [Default], [What it sets]),

        [`--idea-tag-size`],
        [`--idea-label-size`],
        [A tag pill's font size. Follows the ID's size unless you separate them.],

        [`--idea-tag-radius`], [`999px`], [A pill's corner radius.],

        [`--idea-tag-color`, `--idea-tag-bg`],
        [`--idea-id-color`, `rgba(128, 128, 128, .18)`],
        [An untagged-by-`tags-color` pill's text and background. Setting `tags-color` writes these per tag for you.],

        [`--idea-tag-line`],
        [`--idea-border-color`],
        [The tick an outline row draws off the outline's rule, where the row's idea carries a tag.],

        [`--idea-external-color`],
        [`--idea-id-color`],
        [The underline an _outbound_ link takes on hover, in a references block or an idea page's footer---so a link that leaves your rookery reads differently from one that stays in it.],
      )
    ]
  ]

  #reference(<idea-template>, title: [Idea page template])[
    Each @idea:idea[idea] in your rookery gets its own page.
    By default, it shows the idea's title and ID, its body, and the context and backlinks footer.
    You can set a template for it---to add a site header and footer, for example---like so:

    ```typ
    #let idea-page-template(id: none, note: (:), doc) = {
      show: chrome.with(current-page: id)
      doc
    }

    #show: rookery.with(
      idea-page-template: idea-page-template,
    )
    ```
  ]
]

#reference(<as-databases>, title: [Rookeries are databases of ideas])[
  Your rookeries' contents are always _also_ available in Typst through the `#ideas()` function.
  This function returns all of your ideas as a data structure that you may then use to customize your rookery or power downstream applications.
  `ideas` has to be called inside `#context`:

  ```typ
  #import "@rookery/core:0.1.0": ideas, note-href, note-path, idea-body
  #context {
    for e in ideas(tags: "concept") [- #link(e.href, e.text)]

    note-href("as-databases")
    // -> "../ideas/as-databases.html", relative to invocation

    note-path("as-databases")
    // -> "ideas/as-databases.html", path from site root

    idea-body(
      // idea ID
      "as-databases",
      // limit number of lines
      limit: 15,
      // how many layers of children ideas
      depth: 2,
    )
    // -> full content (without chrome)
  }
  ```

  #reference(<ideas-reference>, title: [Ideas reference])[
    The `ideas` function returns an array of dictionaries that each have the following structure:

    #table(
      columns: (auto, 1fr),
      table.header([Field], [What it holds]),

      [`id`], [The full ID, prefix included---`"idea:etal"`.],

      [`name`], [The same ID with the prefix stripped---`"etal"`, the form you write in `#window("etal")`.],

      [`title`, `text`],
      [The title as content, or `none`; and that title flattened to a plain string, `""` where there is none. Take `text` for matching and sorting, `title` for rendering.],

      [`tags`],
      [The idea's @idea:tags[tags], in the order you gave them---which is not alphabetical, and not quite the order they were written, since `#note` and `#todo` prepend their own.],

      [`body`],
      [The idea's body flattened to a plain string, `""` where there is none. Matchable and excerptable, not renderable---for rendering, see `#idea-body` below. A nested idea's text is excluded, since it registers separately and owns its own.],

      [`href`, `page`],
      [A link to the idea's minted page: `href` measured from the page you are calling on, `page` from the site root. Both `none` where nothing mints pages.],

      [`minted`, `updated`], [The idea's dates, or `none`.],
    )
  ]

]
