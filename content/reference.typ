#set document(
  title: "Rookery - Reference",
  date: datetime(year: 2026, month: 8, day: 20),
)

// The Typst type names the argument tables below cite. ROOT-ABSOLUTE, like the
// prelude's own import, so the path does not depend on where in `content/` the
// page citing them sits.
#import "/content/_lib/types.typ": *

#let setup = idea.with(tag: "setup", display-tags: true)
#let reference = idea.with(tag: "reference", display-tags: true)

#ideas-outline(scope: "page")

#setup("getting-started", title: [Getting started])[
  The easiest way to get started with a rookery is by #link("https://rheo.ohrg.org/getting-started")[installing Rheo], a typesetting engine based on Typst.
  #footnote[If you prefer to use native Typst to compile a rookery, see @idea:using-typst]
  Once you have `rheo` on your path, scaffold a new Rheo project:

  ```bash
  rheo init my_rookery
  cd my_rookery
  ```

  Add the following section to the #link("https://rheo.ohrg.org/rheotoml")[rheo.toml] configuration file at the root of the `my_rookery` project:

  ```toml
  [packages.rookery]
  releases = "freecomputinglab/rookery"
  ```

  This allows Rheo to discover the rookery packages.
  Rheo has a built-in development server which will incrementally update your browser as you edit source files:

  ```bash
  rheo watch . --html --open
  ```

  Once this is running, you are all ready to hatch your first idea.
  Do so in `index.typ` (or create a new file if you prefer):

  ```typ
  #import "@rookery/core:0.1.0": idea
  #idea[I want to hatch ideas with rookery.]
  ```

  You're all set!
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
    window-unfurl: 1,
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
      window-unfurl: 1,
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

      [`window-unfurl`],
      [`1`],
      [How many levels of transclusion are allowed before a @idea:windows[window] bottoms out as a link to the idea's own page. `0` allows none. See @idea:window-depth[controlling window unfurl].],

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

      [`hyperlink-target-minted`],
      [`true`],
      [Where every `@idea:etal` in the document lands: `true` on the idea's standalone minted page, `false` in the context it was hatched in. The same parameter `#hyperlink` itself takes. Ignored when `refs` is `false`. See @idea:hyperlinks[hyperlinks].],

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
        // the quieter hover a window gets
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

        [`fold-color`],
        [`rgba(0, 100, 255, .05)`],
        [The hover background on a @idea:windows[window] block, unless that window sets `display-background: false`.],

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

// THE API SURFACE, one nested idea per exported name. `#idea`, `#ideate` and
// `#window` are what a rookery is written WITH, and the rest of the list is
// what it is read and queried with.
//
// AFTER `Site-wide configuration`, not before it: the getting-started page
// hands a reader `#idea[..]` and the `rookery` show rule, and those two are
// what the sections above answer. This is the exhaustive list you come back to
// once you know what a rookery is, not the thing you meet first.
//
// The three written-out references lived on `content/packages/core.typ` until
// the package shelf was cut back to the packages built ON TOP of the core.
// They are not an optional add-on to be browsed alongside `search` and
// `timeline` — they are the reference for the thing itself.
#reference(<api-surface>, title: [API surface])[
  Everything `@rookery/core` exports, one idea apiece. `#idea` hatches an idea
  by hand, `#ideate` infers them from prose already written, and `#window`
  shows one idea inside another page. Those three are written out here, with
  @idea:ideas-reference[`#ideas`], which hands a rookery's own contents back
  to Typst; the rest are stubs for now, listed after them.

  #reference(<idea-reference>, title: [`#idea`])[
    For an intuition on how to think about ideas, see @idea:idea.
    The `#idea` function takes the following arguments, which are all optional:

    #table(
      columns: (auto, auto, 1fr),
      table.header([Argument], [Type], [Description]),
      [`id`],
      [#type-label | #type-string],
      [A unique identifier for the idea, allowing it to be referenced as `@idea:<id>` across the rookery. In the absence of an explicit id, it is derived using a kebab-case form of the idea's `title` and/or a counter.],

      [`title`],
      [#type-content],
      [The idea's title, which appears as both the link text in @idea:hyperlinks[hyperlinks] to the idea and the header text in @idea:windows[windows] on it. ],

      [`body`],
      [#type-content],
      [The idea's content, rendered inside its card and transcluded by any @idea:windows[window] on it. An idea with no body is a title-only stub, which is how a placeholder for an idea not yet written is filed.],

      [`level`],
      [#type-int],
      [The heading depth of the idea's title, so a nested idea can sit under the one containing it. Defaults to `1`.],

      [`tags`],
      [#type-string | #type-array | #type-dict],
      [The idea's @idea:tags[tags], as one name, a list of names, or a dictionary whose values carry arbitrary metadata for the tag. Set at the call site, replacing whatever a constructor bound.],

      [`tag`],
      [#type-string],
      [A single tag that is _merged_ into `tags` rather than replacing it, so a constructor such as `idea.with(tag: "note")` keeps its tag when the call site names tags of its own.],

      [`base-tags`],
      [#type-string | #type-array | #type-dict],
      [As `tag`, but for several tags at once — for a family of ideas that is a narrowing of a broader one, so that every idea the constructor mints is still reachable under the wider tag.],

      [`exclude-tags`],
      [#type-string | #type-array],
      [Tags that drop the idea from this build entirely. An excluded idea is absent rather than hidden: nothing renders where it was written, no page is minted for it, and it appears in no outline, search index or backlink list.],

      [`created`],
      [#type-datetime],
      [The date the idea was written. In its absence the containing document's own `#set document(date: ..)` is used; a date is otherwise never invented.],

      [`display`],
      [#type-dict],
      [What the idea shows of itself, as a dictionary of nine flags — see below.],
    )

    Every `display` key takes a boolean, and defaults to #type-auto: the
    rookery-wide setting given to `#rookery(display: ..)`. An idea states an
    opinion only where it differs from the rest of the rookery.

    ```typ
    #idea(
      display: (
        // the idea's own minted page carries its title as an `<h1>`
        title: true,
        // the `created` date sits at the right-hand end of the hat
        date: true,
        // the tags are worn in the hat as pills, metadata tags excepted
        tags: true,
        // the idea is drawn as a card, with its left rule and indent
        frame: false,
        // the id is shown in the hat as a permalink
        id: true,
        // the minted page footer links back to the page written on
        context: true,
        // the minted page footer lists everything that links here
        backlinks: true,
        // unused by the card itself — seeds what a later window on
        // this idea falls back to when it does not override them
        label: true,
        background: true,
      ),
    )[..]
    ```

    Each key is also an argument in its own right, with the prefix restored —
    `display-frame: false` — and an argument on the same call wins over the
    dictionary's value for that key.
  ]

  #reference(<ideate-reference>, title: [`#ideate`])[
    The one place in rookery where an idea is _inferred_ rather than written.
    `#ideate` takes a block of content and mints ideas from it, either as a
    plain function on one block or as a document show rule — `#show: ideate`
    at the top level hands it the rest of the document. It is opt-in either
    way, and on a paged target it is a passthrough: a PDF of a block of prose
    is that block of prose.

    #table(
      columns: (auto, auto, 1fr),
      table.header([Argument], [Type], [Description]),
      [`body`],
      [#type-content],
      [The content to mint ideas from. The sole positional argument, which is what lets the function double as a show rule.],

      [`separator`],
      [#type-function | #type-none],
      [What starts a new idea: `par` (or `parbreak`) for one idea per paragraph, `heading.where(level: n)` for one per section, or `none` — the default — to mint the whole body as a single idea. A heading standing alone is passed through as structure rather than wrapped as an idea of its own.],

      [`title`],
      [#type-content | #type-function | #type-none],
      [A title given to every idea minted, or a function `(content, labels) => content` called on each section's separating heading to compute its own. The function form is heading mode only, and the heading leaves the body when it is used, since the title is already rendered as the idea's heading.],

      [`name`],
      [#type-function | #type-auto],
      [A function `(content, labels) => str` computing each idea's id from its separating heading — `slug` is exported for exactly this. Defaults to #type-auto, the package counter. A fixed value is refused, as it would mint every idea in the body under one id.],

      [`tags`],
      [#type-string | #type-array | #type-dict | #type-function],
      [@idea:tags[Tags] put on every idea minted, in the same forms `#idea` accepts, or a function `(content, labels) => tags` computing each section's own. An `#ideate-tag(..)` beacon placed in a section's content adds to these, and wins on a conflicting key.],

      [`display`],
      [#type-dict],
      [As on @idea:idea-reference[`#idea`], and read by every idea minted — see below.],
    )

    Two of the nine keys invert `#idea`'s own defaults, and are given here as
    they are read when nothing is said:

    ```typ
    #show: ideate.with(
      display: (
        // an inferred idea is not one anybody named, and a frame around
        // every paragraph is chrome nobody asked for
        frame: false,
        // with more force: an inferred idea's id is a sequence number,
        // which tells a reader nothing
        id: false,
      ),
    )
    ```

    The remaining seven keys — `title`, `date`, `tags`, `context`,
    `backlinks`, `label` and `background` — carry their `#idea` meanings and
    defaults. As there, each key is also an argument in its own right, with
    the prefix restored, and an argument on the same call wins over the
    dictionary's value for that key.

    Every other `#idea` argument is forwarded to every idea minted. Note that
    those ids are generated rather than authored, so an idea that has to be
    linkable is written by hand.

    // NESTED HERE, not out with the rest of the stubs. Both are beacons — a
    // `#metadata` marker written INSIDE a section's content, which `#ideate`
    // picks up as it splits the body — so neither is callable anywhere else,
    // and neither means anything to a reader who is not already reading this.
    // A nested idea registers and mints a page of its own exactly as a
    // top-level one does, so nesting costs them no reachability.
    #reference(<ideate-tag-reference>, title: [`#ideate-tag`])[]

    #reference(<ideate-id-reference>, title: [`#ideate-id`])[]
  ]

  #reference(<window-reference>, title: [`#window`])[
    A @idea:windows[window] shows an idea inside another page — its title, its
    permalink and its body, as one foldable block. It is pure presentation: a
    window registers nothing, mints no page and never re-registers the idea it
    transcludes, so one idea can be windowed anywhere and as often as it earns.

    The ideas shown are named, or selected by tag, or both. Selection is
    rookery-wide, since the registry a window reads is the whole rookery's —
    where the window sits makes no difference to what a tag pulls in.

    #table(
      columns: (auto, auto, 1fr),
      table.header([Argument], [Type], [Description]),
      [`names`],
      [#type-string | #type-label | #type-array],
      [The idea to show, or an array of them. A name is written bare (`"etal"`) or as the full id (`"idea:etal"`), as a string or a label, so `#window("etal")` and `#window(<etal>)` are the same call. Several are passed as one array — `#window(("a", "b"))` — and may be omitted entirely when `tags` does the selecting.],

      [`tagged`],
      [#type-string | #type-array | #type-dict],
      [The @idea:tags[tags] whose ideas to show, instead of naming them or alongside it. A window shows the union of the two, and an idea that is both named and tagged appears once, where it was named.],

      [`match`],
      [#type-string],
      [Whether a tagged idea has to carry `"any"` of the tags — the default — or `"all"` of them.],

      [`sort`],
      [#type-string | #type-auto],
      [The order the ideas are shown in. #type-auto, the default, keeps the named ideas in the order they were written and appends the tag matches by id; `"date"` and `"lexicographic"` order the whole selection instead.],

      [`unfurl`],
      [#type-int | #type-auto],
      [How far transclusion nests. `0` renders the idea as a link to its own page and transcludes nothing, `1` renders it and collapses any window written inside it to a bare permalink, and `n` unfurls `n - 1` levels of those. Defaults to the rookery-wide `#rookery(window-unfurl: ..)`, itself `1`. Windows are all that count: an idea written inside a transcluded body is rebuilt in full whatever the budget.],

      [`limit`],
      [#type-int | #type-none],
      [How many blocks of the body to show — a block being a paragraph or a list, the unit that can be cut without leaving half a sentence. The whole body by default.],

      [`folded`],
      [#type-bool],
      [Whether the window starts closed, leaving its summary alone on the page until a reader opens it.],

      [`foldable`],
      [#type-bool],
      [Whether there is a disclosure at all. `false` renders the body with nothing to click and nothing that can hide it — for a window that _is_ the thing being read rather than a reference to it, such as a slide, where a stray click folding it shut would be a bug. It makes `folded` inert.],

      [`reserve-title`],
      [#type-bool],
      [Whether a titleless window keeps the blank line its summary reserves for the title it does not have. Dead space above a slide's body; no effect on a window whose idea has a title.],

      [`backlink`],
      [#type-bool],
      [Whether the window counts as a link from the page it sits on to the idea it shows. True is right for a window written into an idea's prose; `false` is for a derived view — a deck, an index, a preview — which renders an idea rather than pointing at it, and should not fill that idea's backlinks with pages nobody wrote a link on.],

      [`display`],
      [#type-dict],
      [What the window shows of itself, as a dictionary of six flags — see below.],
    )

    As on @idea:idea-reference[`#idea`], every `display` key takes a boolean and
    defaults to #type-auto, the rookery-wide setting given to
    `#rookery(display: ..)`.

    ```typ
    #window(
      "etal",
      display: (
        // a titleless idea is named by the label derived from its first
        // line; false names it only where it carries an authored title
        label: true,
        // the `created` date sits at the right-hand end of the summary
        date: true,
        // the tags are worn in the summary as pills, metadata tags excepted
        tags: true,
        // the window is drawn as a card, with its left rule and indent
        frame: true,
        // the id is shown in the summary as a permalink
        id: true,
        // the window takes a tint under the cursor
        background: true,
      ),
    )
    ```

    Each key is also an argument in its own right, with the prefix restored —
    `display-frame: false` — and an argument on the same call wins over the
    dictionary's value for that key. `#idea`'s three remaining keys, `title`,
    `context` and `backlinks`, describe an idea's own minted page rather than a
    window onto it, and a window reads none of them.

    One asymmetry is worth carrying: only a _named_ idea takes a backlink from
    the window showing it. A tag selection is not known until the registry can
    be read, and the backlink graph is built before that, so an idea pulled in
    by `tags` lists the windowing page nowhere.
  ]
  // ONE IDEA, NOT TWO. `Rookeries are databases of ideas` and the `Ideas
  // reference` nested inside it were a section and its table, which is one
  // reference wearing two rows of the outline: the outer was prose about
  // `#ideas`, the inner was the shape of what `#ideas` hands back.
  //
  // THE FIELD TABLE IS GONE FOR NOW, and its absence is a gap rather than a
  // duplication — the record's shape (`id`, `name`, `title`/`text`, `tags`,
  // `body`, `href`/`page`, `minted`/`updated`) is documented nowhere else on
  // this page. It goes back when it has been read back off `data.typ` in
  // `@rookery/core`.
  //
  // `idea-href`, `idea-path` and `idea-body` ride along in the sample below
  // rather than carrying stubs of their own, which is the one place this
  // section is not one-idea-per-export.
  #reference(<ideas-reference>, title: [`#ideas`])[
    Your rookeries' contents are always _also_ available in Typst through the `#ideas()` function.
    This function returns all of your ideas as a data structure that you may then use to customize your rookery or power downstream applications.
    `ideas` has to be called inside `#context`:

    ```typ
    #import "@rookery/core:0.1.0": ideas, idea-href, idea-path, idea-body
    #context {
      for e in ideas(tagged: "concept") [- #link(e.href, e.text)]

      idea-href("ideas-reference")
      // -> "../ideas/ideas-reference.html", relative to invocation

      idea-path("ideas-reference")
      // -> "ideas/ideas-reference.html", path from site root

      idea-body(
        // idea ID
        "ideas-reference",
        // limit number of lines
        limit: 15,
        // how many layers of children ideas
        unfurl: 2,
      )
      // -> full content (without chrome)
    }
    ```
  ]

  // TITLE-ONLY STUBS, the rest of the export list. An idea with no body is how
  // this rookery files a reference nobody has written yet — see the `body` row
  // in @idea:idea-reference — and it is not a placeholder in name only: the id
  // is minted, the outline carries a row, and `@idea:hyperlink-reference`
  // resolves from any page. So prose elsewhere can link a function before its
  // reference exists, and writing one is adding a body here rather than hunting
  // down the links that were waiting on it.
  //
  // THE EMPTY `[]` IS LOAD-BEARING. `#idea` takes an optional name and an
  // optional body through one variadic sink, and a lone positional is the
  // BODY — so `#reference(<slug-reference>, title: [`#slug`])` files an idea
  // whose body is the label, under an id slugged from the title. The failure
  // is not quiet but it is remote: `cannot add content and label`, pointing
  // into `idea.typ`. Naming a stub therefore means two positionals, the second
  // empty.
  //
  // WHAT BELONGS ON THIS LIST is every public name in `core`'s `src/lib.typ`
  // re-export chain that is not already documented somewhere on this page:
  // `rookery` is @idea:site-config[site-wide configuration], and `ideas`,
  // `idea-href`, `idea-path` and `idea-body` are @idea:ideas-reference[the
  // database surface]. The `IK`, `WK` and `FNK` marker constants are left off —
  // they are element kinds a downstream package queries for, not functions
  // anybody writes.
  #reference(<hyperlink-reference>, title: [`#hyperlink`])[]

  #reference(<footnote-reference>, title: [`#footnote`])[]

  #reference(<ideas-outline-reference>, title: [`#ideas-outline`])[]

  #reference(<idea-row-reference>, title: [`#idea-row`])[]

  #reference(<idea-row-body-reference>, title: [`#idea-row-body`])[]

  #reference(<slug-reference>, title: [`#slug`])[]



  #reference(<idea-tags-reference>, title: [`#idea-tags`])[]

  #reference(<idea-tag-reference>, title: [`#idea-tag`])[]

  #reference(<tag-index-reference>, title: [`#tag-index`])[]

  #reference(<tag-data-reference>, title: [`#tag-data`])[]
]
