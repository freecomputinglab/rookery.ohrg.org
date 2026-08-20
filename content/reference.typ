#import "template.typ": template
#import "@rheo/rookery:0.4.0": footnote, idea, ideas-outline

#show: template.with(current-page: "install")
#set document(
  title: "Reference",
  date: datetime(year: 2026, month: 8, day: 20),
)

#ideas-outline()

#idea("installing", title: [Installing rookery], tags: ("setup",))[
  The easiest way to get started with a rookery is by #link("https://rheo.ohrg.org/getting-started")[installing Rheo], a typesetting engine based on Typst.
  #footnote[If you prefer to use native Typst to compile a rookery, see @idea:using-typst]

  Once you have `rheo` on your path, you can use rookery in your Rheo project by importing it and hatching an idea:

  ```typ
  #import "@rheo/rookery:0.3.0": idea
  #idea[I want to hatch ideas with rookery.]
  ```

  That's it!

  Your rookery is now ready to nurture your every next idea.
]

== Configuration

#idea(<site-config>, title: [Site-wide configuration], tags: ("setup",))[
  You can configure your rookery by calling a show rule after you import it.

  ```typ
  #import "@rheo/rookery:0.3.0": rookery
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
  #import "@rheo/rookery:0.3.0": rookery
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

  #idea(<config-reference>, title: [Argument reference], tags: ("reference",))[
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
    )
  ]

  #idea(<theming>, title: [Theming a rookery], tags: ("reference",))[
    A rookery's look is five colors, which you hand it as the `theme:` dictionary:

    ```typ
    #import "@rheo/rookery:0.3.0": rookery
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

    #idea(<theme-reference>, title: [Color reference])[
      #table(
        columns: (auto, auto, 1fr),
        table.header([Color], [Default], [What it sets]),

        [`link-color`],
        [`rgba(128, 0, 255, .12)`],
        [The hover background on any rookery link, and the fallback `border-color` takes when you leave it unset.],

        [`fold-color`], [`rgba(0, 100, 255, .05)`], [The hover background on a foldable @idea:windows[window] block.],

        [`id-color`], [`gray`], [The `[idea:etal]` ID's own text.],

        [`date-color`], [`gray`], [An idea's or a window's date, where it is @idea:hatching-ideas[shown].],

        [`border-color`],
        [`link-color`],
        [The left rule that an idea, a window and an @idea:outlining[outline] all carry.],
      )
    ]

    #idea(<class-reference>, title: [Class reference])[

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

        [`.idea-tag-<tag>`],
        [One extra class per tag the idea carries, on each of the three elements that name it: its heading, its box and its outline row.],

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
  ]

  #idea(<idea-template>, title: [Idea page template], tags: ("reference",))[
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
