#set document(
  title: "Rookery - Reference",
  date: datetime(year: 2026, month: 8, day: 20),
)

#import "/content/_lib/types.typ": *

#let setup = idea.with(tag: "setup", display-tags: true)
#let reference = idea.with(tag: "reference", display-tags: true)

#outline(target: idea, scope: "page")

#setup("getting-started", title: [Getting started])[
  The easiest way to get started with a rookery is by #link("https://rheo.ohrg.org/getting-started")[installing Rheo], a typesetting engine based on Typst.
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
    // Names are now `note:etal` rather than `idea:etal`
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
  #import "template.typ": template
  #show: template
  ```

  #reference(<config-reference>, title: [Argument reference])[
    #table(
      columns: (auto, auto, 1fr),
      table.header([Parameter], [Default], [What it sets]),

      [`prefix`],
      [`"idea"`],
      [The namespace an idea's name lives in; non-empty, no `:` (the separator is added for you). See @idea:referencing-ideas[referencing ideas].],

      [`note-dir`],
      [`none`],
      [The directory the minted idea pages are written to. Left unset it is `ideas` under the default prefix, and the prefix itself under any other — `prefix: "maths"` mints `maths/`, not `mathss/`. Names one directory: no `/` and no `:`.],

      [`css-prefix`],
      [`none`],
      [The stem every class this package emits is built from. Left unset it follows `prefix`, so renaming the name namespace renames `.idea-box` to `.note-box` along with it; set it to hold the classes still while the names move. See @idea:class-reference[HTML class reference].],

      [`window-unfurl`],
      [`1`],
      [How many levels of transclusion are allowed before a @idea:windows[window] bottoms out as a link to the idea's own page. `0` allows none. See @idea:window-depth[controlling window unfurl].],

      [`theme`],
      [`(:)`],
      [The ten keys the package will style for you — five colors, three lengths, a font stack, and `tags-color`. Every key but `tags-color` is also a parameter in its own right, and the granular form wins. See @idea:theming[theming a rookery].],

      [`display`],
      [`(:)`],
      [What every idea and window in the rookery shows of itself, as a dictionary of the same nine flags `#idea` takes. This is the bottom of the stack: an idea or a window that leaves a key at #type-auto is asking for the value set here. `date` and `tags` resolve to `false` when nothing is said, the other seven to `true`. Each key is also a parameter in its own right — `display-date: true` — and the granular form wins. See @idea:idea-reference[`#idea`].],

      [`idea-page-template`],
      [`none`],
      [Your own chrome for the standalone page rookery mints per idea. See @idea:idea-template[idea template].],

      [`bibliography`],
      [`none`],
      [Typst's own `#bibliography` arguments, for the single bibliography a rookery's @idea:citations[citations] all draw from.],

      [`index-page`],
      [`true`],
      [Whether to mint `ideas/index.html`, a landing page listing every idea in the rookery. It goes in the same directory the idea pages do, so a rookery that moved them with `note-dir` or `prefix` gets `maths/index.html` rather than `ideas/index.html`. Set it to `false` where your site already publishes an index of its own.],

      [`refs`],
      [`true`],
      [Whether rookery installs the `show ref:` rule that renders `@idea:etal` as the idea rather than a figure number. Set it to `false` to keep Typst's own behaviour, or to install a rule of your own. See @idea:hyperlinks[hyperlinks].],

      [`hyperlink-target-minted`],
      [`true`],
      [Where every `@idea:etal` in the document lands: `true` on the idea's standalone minted page, `false` in the context it was hatched in. The same parameter `#hyperlink` itself takes. Ignored when `refs` is `false`. See @idea:hyperlinks[hyperlinks].],

      [`syndicate`],
      [`false`],
      [Whether each minted page also carries a `<feeds:item>` beacon — the label `@rheo/feeds`'s `items()` reads by default — so a feed package can collect your ideas without either package importing the other. Off by default: a package should not write into another's label namespace unasked. An idea with no date never gets one.],

      [`page-titles`],
      [`"title"`],
      [What the context and backlinks footer on an idea's page calls the pages it lists: `"title"` is Rheo's own spine title, `"path"` the source path with the content directory and the extension dropped — `jobs/cfps`, `institutions`. Rheo derives a title from the file stem, so in a project with a page per directory every `index.typ` is titled 'Index', which is a poor answer to a footer asking where an idea was written; a path is longer and plainer, and unique by construction. A rookery-wide choice, since one idea's footer disagreeing with another's about what a page is called would be worse than either answer.],

      [`invisible-tags`],
      [`()`],
      [Tags that leave no trace in the HTML: no pill in any hat, no `.idea-tag-<tag>` class on the heading, the card, an outline row or an index row, and no generated rule for a `tags-color` entry naming one. Filtering still sees them everywhere — `#window(tagged: ..)`, `#ideas`, `#idea-tag-names`, a search query — which is what makes an invisible tag usable as a build-level key. The presentational complement to `exclude-tags`, which drops the idea itself.],
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

    Every key but `tags-color` can also be passed as a parameter directly to the `rookery` function, which will take precedence over the `theme` dictionary:

    ```typ
    #show: rookery.with(
      theme: MY-THEME,
      link-color: rgb("#ffd166"),
    )
    ```

    `tags-color` has no such parameter: it is a dictionary of its own, keyed by tag, and lives only inside `theme`.

    The five colors each take a Typst color or a raw CSS string.
    Rookery allows a string so that you can specify `rgba(...)`, `color-mix(...)`, `var(--your-own)` and anything else CSS accepts valid.
    The three lengths — `rule-width`, `pad` and `label-size` — take a Typst length or a CSS length string, the string being how you reach the units Typst has no literal for: `px` for a hairline, and the `rem` `label-size` wants.
    `label-font` is a CSS font stack rather than either, passed through unvalidated, and an array of family names is joined for you: `("Berkeley Mono", "monospace")` and `"Berkeley Mono, monospace"` are the same thing.

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

        [`name-color`], [`gray`], [The `[idea:etal]` name's own text.],

        [`date-color`], [`gray`], [An idea's or a window's date, where it is @idea:hatching-ideas[shown].],

        [`border-color`],
        [`link-color`],
        [The left rule that an idea, a window and an @idea:outlines[outline] all carry.],

        [`rule-width`],
        [`2px`],
        [How thick that rule is. The card's corner is arithmetic against it, so the tab the name straddles stays shut when you move it.],

        [`pad`],
        [`0.5em`],
        [The padding every rookery block measures from---an idea's box, a window's, and the indent a nested one takes.],

        [`label-font`],
        [`monospace`],
        [The face the `[idea:etal]` name is set in, and the outline's 'Contents' title with it. Both are machinery rather than writing, so both leave the prose face behind.],

        [`label-size`],
        [`0.57rem`],
        [The size of that name. Load-bearing beyond the label: the tab's lift, a window's summary and the footer's padding are all measured against it, so the corner closes at whatever size you choose. `rem` rather than `em`, so it does not shrink again inside a window.],

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

        [`.idea-head`, `.idea-tab`],
        [The heading group, and the short top rule the name straddles at the card's corner.],

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
        [The fold: `-details` the `<details>`, `-summary` the row you click, `-title` the name in that row, `-body` what folds away under it. The date beside the title is `.idea-date`, the same class it wears in a heading.],

        [`.idea-window-more*`],
        [The second fold a `limit:` makes _inside_ the body: `.idea-window-more` its `<details>`, `-more-summary` the shown blocks you click to see the rest, and `.idea-window-ellipsis` the `…` at the end of them.],

        [`.idea-outline*`],
        [A page's @idea:outlines[outline]: `.idea-outline` the list at each level of nesting, `-title` its "Contents" label, `-row` one row per idea.],

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

        [`.idea-row*`],
        [One row of an @idea:idea-row-reference[`#idea-row`] list: `.idea-row` the `<li>`, `-when` its date cell, `-title` the title, `-cell` each extra cell, `-badges` the chip strip at the end. `@rookery/search` and `@rookery/timeline` draw the same row, so a rule of yours here reaches all three.],

        [`.idea-index-count`], [The "*n* ideas" line on the minted index page.],
      )

      Every one of those elements also carries a `data-rookery` attribute
      naming the same thing without the prefix---`.idea-box` is
      `[data-rookery="box"]`, `.idea-window-summary` is
      `[data-rookery="window-summary"]`---and it is the attribute, not the
      class, that rookery's own stylesheet selects on. The two say the same
      thing, so write whichever reads better in your CSS; the attribute is
      there because `css-prefix` moves the classes and nothing should have to
      follow them to find an element. `.idea-window-plain` is the one that
      does not repeat itself: a plain window is `[data-rookery="window"]`
      wearing `data-rookery-plain` besides.

      Anything that names a tag---a card, a window, a pill, an outline row, an
      index row, a badge---carries one more, `data-rookery-tags`, listing
      those tag names, minus any made invisible by `invisible-tags`.
    ]

    #reference(<css-reference>, title: [CSS variable reference])[
      You can override any value from the @idea:theme-reference[theme reference] as a CSS variable, as well as other aspects of a rookery's appearance.

      #table(
        columns: (auto, auto, 1fr),
        table.header([Property], [Default], [What it sets]),

        [`--idea-tag-size`],
        [`--idea-label-size`],
        [A tag pill's font size. Follows the name's size unless you separate them.],

        [`--idea-tag-radius`], [`999px`], [A pill's corner radius.],

        [`--idea-tag-color`, `--idea-tag-bg`],
        [`--idea-name-color`, `rgba(128, 128, 128, .18)`],
        [An untagged-by-`tags-color` pill's text and background. Setting `tags-color` writes these per tag for you.],

        [`--idea-tag-line`],
        [`--idea-border-color`],
        [The tick an outline row draws off the outline's rule, where the row's idea carries a tag.],

        [`--idea-external-color`],
        [`--idea-name-color`],
        [The underline an _outbound_ link takes on hover, in a references block or an idea page's footer---so a link that leaves your rookery reads differently from one that stays in it.],
      )
    ]
  ]

  #reference(<idea-template>, title: [Idea page template])[
    Every @idea:idea[idea] in your rookery gets its @idea:standalone-idea-pages[own standalone page].
    By default, this page shows the idea's title and name, its body, and the context and backlinks footer.

    You can customize the idea page's chrome when you first instantiate rookery, like so:

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
// A NAME NESTS UNDER THE EXPORT IT IS REACHED THROUGH, which is the whole
// ordering rule. Usually the prefix says which that is — every `#idea-*`
// accessor sits inside `#idea`, both `#ideate-*` beacons inside `#ideate` —
// and where it does not, the CALL SITE does: `#slug` under `#ideate` (it exists
// for that function's `name:`), `#tag-index` and `#tag-data` under `#ideas`.
//
// SO THE RULE IS NOT THE PREFIX TREE, and the three that nest by call site are
// why. A prefix tree would leave `#slug` and `#tag-data` stranded at the top
// level as names with nothing to hang them on, which is precisely the reader
// problem this ordering exists to solve: a reader who has found `#ideate` has
// found everything they need to drive it, whatever those things are spelled.
//
// `#idea-row` and `#idea-row-body` are the stretch in the other direction —
// they draw a row in a LIST of ideas rather than touching one — but splitting
// them out would mean the prefix half of the rule holds for five names and not
// for seven, which costs more than the imprecision does.
//
// `#ideas-outline` HAS NO IDEA OF ITS OWN, and that is this rule reaching its
// limit rather than an exception to it: it and `#outline` are ONE function
// reached two ways, so nesting one under the other produced a reference whose
// only content was "this forwards to that". They are documented as one idea
// under `#outline`, the name a reader should write, with the other named
// inside it.
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
  shows one idea inside another page: those three are what a rookery is
  _written_ with, and they come first. Then what it is read with — a link, a
  footnote, an outline. Last is @idea:ideas-reference[`#ideas`], which stops
  rendering a rookery and hands its whole contents back to Typst as data, and
  which everything you might build on top of this package begins from.

  A name nests under the export it is reached through, so finding a function
  below means finding what you would have been holding when you needed it.
  Mostly the prefix says where: every `#idea-*` accessor sits inside
  @idea:idea-reference[`#idea`], and both `#ideate-*` beacons inside
  @idea:ideate-reference[`#ideate`]. Where it does not, the call site does —
  @idea:slug-reference[`#slug`] under `#ideate`, whose `name:` it is written
  for, and @idea:tag-index-reference[`#tag-index`] with
  @idea:tag-data-reference[`#tag-data`] under
  @idea:ideas-reference[`#ideas`].

  Two kinds of name are left off the list. `#rookery` is the show rule, documented
  above as @idea:site-config[site-wide configuration]; the `IK`, `WK` and `FNK`
  marker constants are element kinds a downstream package queries for, not
  functions anybody writes.

  #reference(<idea-reference>, title: [`#idea`])[
    For an intuition on how to think about ideas, see @idea:idea.
    The `#idea` function takes the following arguments, which are all optional:

    #table(
      columns: (auto, auto, 1fr),
      table.header([Argument], [Type], [Description]),
      [`name`],
      [#type-label | #type-string],
      [A unique name for the idea, allowing it to be referenced as `@idea:<name>` across the rookery. Positional, and written either as a label or as a string---`#idea(<etal>)` and `#idea("etal")` are the same call. In the absence of an explicit name, an idea with a `title` takes a slug of it; an idea with no usable title instead takes a slug of its own body plus a content digest, as described under @idea:auto-naming[auto-naming].],

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

      [`display`], [#type-dict], [What the idea shows of itself, as a dictionary of nine flags — see below.],
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
        // the name is shown in the hat as a permalink
        name: true,
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

    Everything else spelled `idea-` reads one back out, and is nested here: its
    tags, where its page sits, its body, and the row that stands for it in a
    list.

    #reference(<idea-tag-names-reference>, title: [`#idea-tag-names`])[
      One idea's tag names, as a flat array.

      ```typ
      #import "@rookery/core:0.1.0": idea, idea-tag-names

      #idea("etal", title: [Et al.], tags: (note: none, draft: none, priority: 1))[
        Attribution flattens a crowd into one name.
      ]

      #context idea-tag-names("etal")   // -> ("note", "draft", "priority")
      ```

      Every key, valued tags included — `priority` comes back alongside the two
      plain tags, because a tag carrying metadata is still a tag. This is the
      question of what an idea is tagged, not of what those tags hold. Key order
      is unspecified.

      `()` comes back both for an untagged idea and for a name that does not
      exist. A missing idea is not an error here: a caller asking what something
      is tagged is filtering, not dereferencing. Must be called inside
      `#context`.

      Where you are walking the whole rookery, read the `tags` field off
      @idea:ideas-reference[`#ideas`] instead: this resolves the registry once
      per idea, where `#ideas` resolves it once for the pass.
    ]

    #reference(<idea-tag-value-reference>, title: [`#idea-tag-value`])[
      One tag's value on one idea.

      ```typ
      #import "@rookery/core:0.1.0": idea, idea-tag-value

      #idea("etal", title: [Et al.], tags: (note: none, priority: 1))[
        Attribution flattens a crowd into one name.
      ]

      #context {
        idea-tag-value("etal", "priority")            // -> 1
        idea-tag-value("etal", "note")                // -> none, a plain tag
        idea-tag-value("etal", "nope", default: 4)    // -> 4
      }
      ```

      Takes the same name forms as @idea:idea-tag-names-reference[`#idea-tag-names`], and
      returns `default` where the idea does not exist or carries no such key.

      A plain tag's value is #type-none, which is indistinguishable from a
      `default` of #type-none on a key that is absent. This function answers what
      a tag is set to, and a plain tag is set to nothing; ask `#idea-tag-names` or
      @idea:tag-data-reference[`#tag-data`] when the question is presence. Must
      be called inside `#context`.
    ]

    #reference(<idea-href-reference>, title: [`#idea-href`])[
      Where an idea's minted page sits, _relative to the page you are calling
      from_. Takes a bare name, a full name or a label — the same forms
      @idea:window-reference[`#window`] and @idea:hyperlink-reference[`#hyperlink`]
      take — and must be called inside `#context`.

      ```typ
      #import "@rookery/core:0.1.0": idea, idea-href

      #idea("etal", title: [Et al.])[
        Attribution flattens a crowd into one name.
      ]

      #context idea-href("etal")
      // -> "ideas/etal.html"    called from a root page
      // -> "../ideas/etal.html" called from a page one directory down
      ```

      The depth arithmetic is measured from the calling page, so the same idea
      yields a different string on a nested page than on the root one. That is
      the point of the function, and it is why a caller must never cache the
      answer across pages.

      #type-none wherever no page is minted: a plain `typst compile` with no
      Rheo, and the combined PDF target.
    ]

    #reference(<idea-path-reference>, title: [`#idea-path`])[
      The same page as @idea:idea-href-reference[`#idea-href`], from the site
      root rather than from here.

      ```typ
      #import "@rookery/core:0.1.0": idea, idea-path

      #idea("etal", title: [Et al.])[
        Attribution flattens a crowd into one name.
      ]

      #context idea-path("etal")
      // -> "ideas/etal.html", from either page above
      ```

      Reach for it where the caller has no page of its own to measure depth
      from — a feed configuration or a sitemap invoked once from shared code
      rather than from a page. It is #type-none under the same two conditions
      `#idea-href` is.
    ]

    #reference(<idea-body-reference>, title: [`#idea-body`])[
      One idea's body, rendered, with none of a
      @idea:window-reference[window]'s chrome: no summary line, no permalink, no
      disclosure. For a consumer that wants to _show_ an idea rather than
      describe it — a preview pane, a card in a view of the caller's own
      design — where `#ideas`' `body` field only hands over plain text.

      ```typ
      #import "@rookery/core:0.1.0": idea, idea-body

      #idea("etal", title: [Et al.])[
        Attribution flattens a crowd into one name.

        The convention is older than the citation styles that inherited it.
      ]

      // anywhere after it, on any page
      #idea-body("etal")            // both paragraphs, no title, no permalink
      #idea-body("etal", limit: 1)  // the first paragraph alone
      ```

      #table(
        columns: (auto, auto, 1fr),
        table.header([Argument], [Type], [Description]),
        [`name`], [#type-string | #type-label], [The idea to render, in the same name forms every accessor here takes.],

        [`unfurl`],
        [#type-int | #type-auto],
        [The transclusion budget, as on `#window`. Pinned at `1` rather than #type-auto, so a preview's size stays bounded however deeply the idea it shows nests. `0` asks for no unfurling and still renders the body — there is no chrome here to fall back to a link.],

        [`limit`],
        [#type-int | #type-none],
        [How many blocks of the body to show, the same unit `#window`'s own `limit` cuts by. The whole body by default.],
      )

      It supplies its own `#context`, unlike the data accessors on this page, so
      it can be called anywhere. The body comes wrapped in the same classes a
      window's does, minus the box, so every rule the stylesheet already writes
      for prose inside a window — link colors, code, lists, footnotes — applies
      with nothing for a consumer to restyle.
    ]

    #reference(<idea-row-reference>, title: [`#idea-row`])[
      One row of a list of ideas: a date, a title, cells and badges, as an
      `<li>`. The shape `@rookery/search` and `@rookery/timeline` both draw, kept
      in core so that a project reaching a row through one of those packages
      still gets core's CSS with it.

      ```typ
      #import "@rookery/core:0.1.0": idea, ideas, idea-row

      #idea(
        "etal",
        title: [Et al.],
        tags: (note: none),
        created: datetime(year: 2026, month: 8, day: 20),
      )[Attribution flattens a crowd into one name.]

      #context html.elem("ul", ideas(tagged: "note").map(e => idea-row(
        when: e.created.display("[day] [month repr:short]"),
        iso: e.created.display("[year]-[month]-[day]"),
        title: e.label,
        href: e.href,
        tags: e.tags,
        badges: e.tags.map(t => (text: t, tag: t)),
      )).join())
      ```

      The row is fed from @idea:ideas-reference[`#ideas`] rather than from the
      idea directly, which is the usual shape: a view selects its ideas, decides
      what their dates mean, and hands the row cells that are already content.

      #table(
        columns: (auto, auto, 1fr),
        table.header([Argument], [Type], [Description]),
        [`when`], [#type-content | #type-none], [The date cell, already formatted. #type-none draws an em dash.],

        [`iso`],
        [#type-string | #type-none],
        [A machine-readable date, which wraps `when` in a `<time>` element carrying it.],

        [`soft`],
        [#type-bool],
        [Whether this date answers a different question than the list asked — a booked event standing in for a deadline. Dropped silently on a row with no date, which makes no such claim.],

        [`when-class`, `when-attrs`],
        [#type-string | #type-array, #type-dict],
        [Extra classes and attributes on the date cell, for a consumer that bands a deadline by how close it is. Core defines none of these names and styles none of them.],

        [`title`], [#type-content], [The row's title.],

        [`href`], [#type-string | #type-none], [Where the title links. #type-none renders it as a span instead.],

        [`badges`],
        [#type-array],
        [The chip strip at the end of the row. A `(text: .., tag: ..)` dictionary draws the ordinary chip, wearing the same `.idea-tag-<tag>` class a pill and an outline row do, so a themed tag colors itself; anything else is placed verbatim and the caller owns its markup. An empty strip is omitted rather than drawn empty, since a childless span still takes a grid track.],

        [`cells`],
        [#type-array],
        [Extra content cells between the title and the badges — a host institution, a path — for what a reader scans down a column for rather than reads inside the title.],

        [`tags`],
        [#type-array],
        [Tag names, which become `.idea-tag-<tag>` classes and a `data-rookery-tags` attribute on the `<li>`.],

        [`extra`, `attrs`],
        [#type-array, #type-dict],
        [Extra classes and attributes on the `<li>`, merged _under_ the classes this function computes so a caller cannot drop the row's own. This is what lets `@rookery/search`'s panels hang their `data-panel-*` attributes off a row without re-emitting its markup.],
      )

      Cells arrive formatted, and that is the whole of the design: the row asks
      no questions about what a date or a badge means, so one row shape serves a
      log-derived queue, a filter panel and a hand-built table of submissions,
      none of which agree about what a date is. It carries no JavaScript —
      interaction stays in `@rookery/search`.

      HTML only, and deliberately: a paged target has no grid to align and no
      anchor to click, so every view in this family keeps its own branch that
      builds a plain `list(..)` there. Calling it on a paged target fails with a
      message about the mistake rather than about the element.
    ]

    #reference(<idea-row-body-reference>, title: [`#idea-row-body`])[
      The same row, without the `<li>` around it. It takes every
      @idea:idea-row-reference[`#idea-row`] argument except the three that
      describe that wrapper — `tags`, `extra` and `attrs` — and is for a caller
      that owns the list item itself.

      ```typ
      #import "@rookery/core:0.1.0": idea, ideas, idea-row-body

      #idea(
        "etal",
        title: [Et al.],
        tags: (note: none),
        created: datetime(year: 2026, month: 8, day: 20),
      )[Attribution flattens a crowd into one name.]

      #context html.elem("ul", ideas(tagged: "note").map(e => html.elem(
        // the `<li>` is the caller's, with its own classes and attributes
        "li",
        attrs: (class: "my-row", data-my-kind: "note"),
        idea-row-body(
          when: e.created.display("[day] [month repr:short]"),
          iso: e.created.display("[year]-[month]-[day]"),
          title: e.label,
          href: e.href,
        ),
      )).join())
      ```

      The split is forced rather than tidy: `@rookery/search` ships two widgets
      that want this shape and disagree about who owns the `<li>`. Its filter
      panel builds its own list and uses `#idea-row` as the item; its general
      panel wraps whatever it is handed in an item of its own, which with
      `#idea-row` would nest one `<li>` inside another.
    ]
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
      [A function `(content, labels) => str` computing each idea's name from its separating heading — `slug` is exported for exactly this. Defaults to #type-auto, which slugs the heading the same way an unnamed `#idea`'s title is slugged, falling back to `#idea`'s own untitled-naming rule when the heading yields no usable slug. A fixed value is refused, as it would mint every idea in the body under one name.],

      [`tags`],
      [#type-string | #type-array | #type-dict | #type-function],
      [@idea:tags[Tags] put on every idea minted, in the same forms `#idea` accepts, or a function `(content, labels) => tags` computing each section's own. An `#ideate-tag(..)` beacon placed in a section's content adds to these, and wins on a conflicting key.],

      [`display`], [#type-dict], [As on @idea:idea-reference[`#idea`], and read by every idea minted — see below.],
    )

    Two of the nine keys invert `#idea`'s own defaults, and are given here as
    they are read when nothing is said:

    ```typ
    #show: ideate.with(
      display: (
        // an inferred idea is not one anybody named, and a frame around
        // every paragraph is chrome nobody asked for
        frame: false,
        // with more force: an inferred idea's name is a sequence number,
        // which tells a reader nothing
        name: false,
      ),
    )
    ```

    The remaining seven keys — `title`, `date`, `tags`, `context`,
    `backlinks`, `label` and `background` — carry their `#idea` meanings and
    defaults. As there, each key is also an argument in its own right, with
    the prefix restored, and an argument on the same call wins over the
    dictionary's value for that key.

    Every other `#idea` argument is forwarded to every idea minted. Note that
    those names are generated rather than authored, so an idea that has to be
    linkable is written by hand.

    // NESTED HERE, not out with the rest of the stubs. Both are beacons — a
    // `#metadata` marker written INSIDE a section's content, which `#ideate`
    // picks up as it splits the body — so neither is callable anywhere else,
    // and neither means anything to a reader who is not already reading this.
    // A nested idea registers and mints a page of its own exactly as a
    // top-level one does, so nesting costs them no reachability.
    #reference(<ideate-tag-reference>, title: [`#ideate-tag`])[
      A beacon that tags the idea minted around it, written inside the prose
      rather than at the `#ideate` call site. It takes tags in the same four
      forms `#idea`'s own `tags` argument accepts — nothing, one name, a list
      of names, or a dictionary carrying metadata — and adds to whatever
      `#ideate(tags: ..)` already put on every idea, winning on a key the two
      disagree about.

      ```typ
      #show: ideate.with(separator: heading.where(level: 2), tags: "note")

      == A section
      #ideate-tag(("draft", "phd"))
      Its prose, minted as an idea tagged note, draft and phd.
      ```

      Under `separator: heading` the beacon may sit anywhere in the section's
      content; inside a paragraph it tags the group it is written in. It
      renders nothing of itself.
    ]

    #reference(<ideate-name-reference>, title: [`#ideate-name`])[
      The same device for a name: a beacon naming the one idea minted around
      it, overriding whatever `name` would otherwise have derived.

      ```typ
      == A section
      #ideate-name("the-name-i-want")
      Its prose, minted under `idea:the-name-i-want`.
      ```

      Unlike a `name` function, this works under every separator — it carries
      its own value rather than reading one off a heading — which makes it the
      way to pin the one inferred idea that has to be linkable without naming
      the rest.
    ]

    #reference(<slug-reference>, title: [`#slug`])[
      A URL-safe slug from content or a string: lowercased, every run of
      characters outside `a`--`z` and `0`--`9` collapsed to a single hyphen, with
      none left at either end.

      ```typ
      #import "@rookery/core:0.1.0": ideate, slug
      #show: ideate.with(
        separator: heading.where(level: 2),
        name: (h, labels) => "sec-" + slug(h),
      )
      ```

      Exported for exactly that: the `name` function above, naming each
      section's idea after its own heading, so inserting or reordering sections
      does not renumber every name after it.

      Text that is nothing but punctuation slugs to the empty string, and the
      build fails rather than minting an idea under an empty name.
    ]
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
      [The idea to show, or an array of them. A name is written bare (`"etal"`) or in full (`"idea:etal"`), as a string or a label, so `#window("etal")` and `#window(<etal>)` are the same call. Several are passed as one array — `#window(("a", "b"))` — and may be omitted entirely when `tags` does the selecting.],

      [`tagged`],
      [#type-string | #type-array | #type-dict],
      [The @idea:tags[tags] whose ideas to show, instead of naming them or alongside it. A window shows the union of the two, and an idea that is both named and tagged appears once, where it was named.],

      [`match`],
      [#type-string],
      [Whether a tagged idea has to carry `"any"` of the tags — the default — or `"all"` of them.],

      [`filter`],
      [#type-function | #type-none],
      [A predicate of your own over the idea's tag dictionary, ANDed with `tagged` and `match` rather than replacing them. It is what expresses a selection those two cannot: an exclusion, or an OR of ANDs. The same argument `#ideas` and `#outline` take. On `#window`, the ideas it selects also register no backlinks, for the reason given below.],

      [`sort`],
      [#type-string | #type-auto],
      [The order the ideas are shown in. #type-auto, the default, keeps the named ideas in the order they were written and appends the tag matches by name; `"date"` and `"lexicographic"` order the whole selection instead.],

      [`unfurl`],
      [#type-int | #type-auto],
      [How far transclusion nests. `0` renders the idea as a link to its own page and transcludes nothing, `1` renders it and collapses any window written inside it to a bare permalink, and `n` unfurls `n - 1` levels of those. Defaults to the rookery-wide `#rookery(window-unfurl: ..)`, itself `1`. Windows are all that count: an idea written inside a transcluded body is rebuilt in full whatever the budget.],

      [`limit`],
      [#type-int | #type-none],
      [How many blocks of the body to show — a block being a paragraph or a list, the unit that can be cut without leaving half a sentence. The whole body by default; in HTML and EPUB every footnote in the note is listed regardless, since the tail sits collapsed rather than dropped, and one written in the shown blocks renders twice — under a paged target, where the tail is truly dropped, only the footnotes that survive the cut are listed.],

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
      [Whether the window counts as a link from the page it sits on to the idea it shows. True is right for a window written into an idea's prose; `false` is for a derived view — a deck, an index, a preview — which renders an idea rather than pointing at it, and should not fill that idea's backlinks with pages nobody wrote a link on. `true`, the default, means every idea the window shows gains a backlink from it, named or tagged alike.],

      [`display`], [#type-dict], [What the window shows of itself, as a dictionary of six flags — see below.],
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
        // the name is shown in the summary as a permalink
        name: true,
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

    A tag selection backlinks exactly as a named one does: every idea a
    `tagged` window matches takes a backlink, both from the page the window
    sits on and from the idea whose prose it is written in. The one selection
    that registers nothing is `filter`---a predicate cannot ride in the
    metadata the backlink walk reads, and it is ANDed with `tagged` rather
    than replacing it.
  ]
  #reference(<hyperlink-reference>, title: [`#hyperlink`])[
    A plain link to an idea, and the renderer behind every `@idea:etal` in your
    prose. For how a hyperlink reads alongside a window, see
    @idea:hyperlinks[hyperlinks].

    ```typ
    #import "@rookery/core:0.1.0": hyperlink
    #hyperlink("etal")[see this]
    #hyperlink(<etal>, hyperlink-target-minted: false)[see this, in context]
    ```

    #table(
      columns: (auto, auto, 1fr),
      table.header([Argument], [Type], [Description]),
      [`name`],
      [#type-string | #type-label],
      [The idea to link to, written bare (`"etal"`) or in full, as a string or a label. Positional, and required in a direct call.],

      [`body`],
      [#type-content],
      [The link text. Positional, and required: an explicit call has no title to fall back on, where `@idea:etal` does.],

      [`hyperlink-target-minted`],
      [#type-bool],
      [Where the link lands: `true`, the default, on the idea's own minted page, `false` on the anchor where it was hatched.],
    )

    The same function is `@idea:etal`'s renderer, installed as a `show ref:`
    rule. An idea's label lives on a hidden anchor, so without the rule a bare
    reference resolves to that anchor and renders as a figure _number_ —
    `#show: rookery` installs it for you, and `refs: false` declines it.

    ```typ
    #show ref: hyperlink                                         // the minted page
    #show ref: hyperlink.with(hyperlink-target-minted: false)    // the anchor
    ```

    In reference mode the link names its target: the idea's title, or the name
    derived from its first line where it has none, or its bare name as a last
    resort — the same name an index row and a search hit call it by, so the
    three cannot disagree. `@idea:etal[custom text]` overrides that.

    Existence is checked at the call site, so a typo fails the build rather
    than shipping a dangling link. An idea @idea:idea-reference[excluded] from
    the build is a different matter: the body stays and only the link goes,
    since a hyperlink sits inside a sentence you wrote and deleting it would
    break the grammar around it.
  ]

  #reference(<footnote-reference>, title: [`#footnote`])[
    Rookery's own `#footnote`, which shadows Typst's and scopes a note to the
    idea it is written in. Import it alongside `#idea` and write footnotes
    exactly as before — the single positional argument is the footnote's body.
    That import is needed in every file that writes a footnote, since Typst's
    imports are per file; an idea body that reaches Typst's own `#footnote`
    instead of rookery's fails the build, with an error naming the import to
    add.

    ```typ
    #import "@rookery/core:0.1.0": idea, footnote
    #idea("etal")[A claim#footnote[The evidence.] worth qualifying.]
    ```

    Inside an idea, the enclosing idea claims the note, numbers it against
    itself and lists it in its own Footnotes block — on every surface that idea
    appears on. Outside one, the rule `#show: rookery` installs falls back to
    Typst's own footnote, so a note in ordinary page prose behaves as it always
    did. See @idea:footnotes[footnotes] for what idea-local numbering means for
    a page carrying several.
  ]

  // ONE IDEA, NOT TWO. `#outline` and `#ideas-outline` are one function reached
  // two ways — the second IS what the first calls — so documenting them apart
  // meant one argument table and, beside it, a second reference whose whole
  // content was "this forwards to that". The table belongs under the name a
  // reader should write, which is `#outline`.
  //
  // `<outline-reference>` IS THE SURVIVING NAME, and `<ideas-outline-reference>`
  // is gone rather than kept as an alias: a rookery name is a Typst label, so a
  // retired one is not a dangling link but a compile error at every inbound
  // `@idea:` — which is the behaviour that makes retiring one safe.
  #reference(<outline-reference>, title: [`#outline`])[
    A contents list over the ideas in your rookery, derived from how you nest
    them. See @idea:outlines[outlining ideas] for what it lists and what it
    leaves out.

    Typst's own idiom for an outline over something other than headings is a
    `target:` argument, so rookery overloads that call rather than asking you to
    remember a second name:

    ```typ
    #import "@rookery/core:0.1.0": idea, outline
    #outline(target: idea, scope: "page", depth: 2)   // the ideas on this page
    #outline()                                        // Typst's own, over headings
    ```

    `target: idea` takes the arguments below; every other target proxies
    straight through to Typst's `#outline`, unchanged. Passing `tagged`,
    `match`, `filter` or `scope` _without_ `target: idea` is refused by name,
    rather than forwarded into Typst's outline to be rejected there with a
    message about an argument you did not think you were writing.

    #table(
      columns: (auto, auto, 1fr),
      table.header([Argument], [Type], [Description]),
      [`title`],
      [#type-content | #type-auto | #type-none],
      [The label above the list. #type-auto prints 'Contents', matching Typst's own `#outline`; #type-none omits it; any other content replaces it. Rendered as a real heading that neither self-lists in a later outline nor takes the document's heading numbering.],

      [`depth`],
      [#type-int | #type-none],
      [How many levels of nesting to show, counted as Typst counts heading levels: a top-level idea is `1`. Levels of containment, not of pages.],

      [`scope`],
      [#type-string],
      [How wide to cast: `"rookery"`, the default, lists every idea in the rookery as one tree in spine order; `"page"` narrows to the ideas written on this page. The whole spine compiles as one document, so the wider reading costs nothing extra.],

      [`tagged`],
      [#type-string | #type-array | #type-dict | #type-none],
      [The @idea:tags[tags] to restrict the outline to.],

      [`match`],
      [#type-string],
      [Whether a listed idea has to carry `"any"` of those tags — the default — or `"all"` of them.],

      [`filter`],
      [#type-function | #type-none],
      [A predicate over the idea's tag dictionary, ANDed with the two above. The same trio `#window` and `#ideas` take.],
    )

    Filtering happens before `depth` is applied, and that order is the point:
    `depth: 1` means the top level of what you asked for, not whatever survived
    from the top level of everything. An idea whose parent was filtered out is
    promoted to its nearest surviving ancestor's level rather than left
    dangling.

    Rows are not grouped under per-page headings. An idea's name is flat and
    travels between files precisely so a reader never has to know which file
    holds it; an index that led with filenames would put that back.

    The same function is exported as `#ideas-outline` as well, taking the same
    six arguments with no `target:` to write:

    ```typ
    #import "@rookery/core:0.1.0": ideas-outline
    #ideas-outline(scope: "page", depth: 2)
    ```

    Prefer `#outline`. Reach for `#ideas-outline` where you would rather not
    shadow Typst's own `#outline` at all — a project that imports this package
    with `*`, or one with `show outline:` rules of its own to keep clear of.
    Nothing is lost by the shadow itself, since every non-`idea` target
    proxies through untouched; what you are choosing is whether the name in
    your file is Typst's or rookery's.
  ]

  // ONE IDEA, NOT TWO. `Rookeries are databases of ideas` and the `Ideas
  // reference` nested inside it were a section and its table, which is one
  // reference wearing two rows of the outline: the outer was prose about
  // `#ideas`, the inner was the shape of what `#ideas` hands back.
  //
  // THE FIELD TABLE IS BACK, read off `data.typ` in `@rookery/core` — the row
  // the walk builds, not the internal record. `minted`/`updated`, which an
  // earlier version of this page named, were never fields: the accessors are
  // @idea:idea-href-reference[`#idea-href`] and
  // @idea:idea-path-reference[`#idea-path`], and the row carries their answers
  // as `href` and `page`.
  //
  // `tag-index` AND `tag-data` NEST HERE under the page's own rule (see
  // `<api-surface>`), placed by CALL SITE rather than by prefix: `ideas(index:
  // ..)` is the only way to reach the first, and the second is the bulk join
  // partner for the rows this function returns. A reader who has not just read
  // the row table has nothing to hang either on.
  #reference(<ideas-reference>, title: [`#ideas`])[
    Your rookeries' contents are always _also_ available in Typst through the `#ideas()` function.
    This function returns all of your ideas as a data structure that you may then use to customize your rookery or power downstream applications.
    `ideas` has to be called inside `#context`, since it reads the rookery's registry:

    ```typ
    #import "@rookery/core:0.1.0": ideas
    #context {
      for e in ideas(tagged: "concept") [- #link(e.href, e.label)]
    }
    ```

    #table(
      columns: (auto, auto, 1fr),
      table.header([Argument], [Type], [Description]),
      [`tagged`],
      [#type-string | #type-array | #type-dict | #type-none],
      [The @idea:tags[tags] to narrow the corpus to. The same argument `#window` and `#outline` take, with the same meanings.],

      [`match`],
      [#type-string],
      [Whether a matching idea has to carry `"any"` of those tags — the default — or `"all"` of them.],

      [`filter`],
      [#type-function | #type-none],
      [A predicate over the idea's tag dictionary, ANDed with `tagged` and `match`. Applied _before_ the row is built, so an idea you drop never pays for its own conversions — which is the whole reason it is an argument here rather than a `.filter()` on the result.],

      [`sort`],
      [#type-string | #type-auto],
      [The order the rows come back in. #type-auto and `"lexicographic"` both mean by name; `"date"` puts the newest `created` first and undated ideas last.],

      [`index`],
      [#type-dict | #type-none],
      [A @idea:tag-index-reference[`#tag-index`] projection, whose declared fields are merged onto every row. The supported way to filter or sort on a tag _value_.],

      [`values`],
      [#type-bool],
      [Whether each row also carries a `tags-dict` field holding the idea's whole tag dictionary, values included. Off by default, and absent rather than empty when off, so a consumer cannot read `(:)` off a row and conclude the idea is untagged.],
    )

    Each row is a dictionary of ten fields, in every call:

    #table(
      columns: (auto, auto, 1fr),
      table.header([Field], [Type], [What it holds]),
      [`id`], [#type-string], [The full name, prefix included — `"idea:etal"`.],

      [`name`],
      [#type-string],
      [The same name with the prefix stripped — `"etal"`. What every accessor on this page takes.],

      [`title`],
      [#type-content | #type-none],
      [The authored title, as content, refs and all. #type-none where the idea has none.],

      [`text`],
      [#type-string],
      [That same title as plain text, `""` where there is none. A reference inside it reads as its target's name rather than as a number.],

      [`label`],
      [#type-string],
      [What to _call_ this idea, and never empty: the title as text, else the body's first sixty characters, else the idea's own name. Reach for this wherever an idea is referred to rather than rendered — a row in an index, a node in a graph, a sort key — and the `if r.text == "" { r.name }` dance stops being yours to write.],

      [`tags`],
      [#type-array],
      [The tag _names_, every key including the valued ones, `()` where there are none. A flat array of strings, so it drops into a JSON index unchanged. Tags are unordered and nothing may depend on the sequence; the values live in `tags-dict` and @idea:tag-data-reference[`#tag-data`].],

      [`body`],
      [#type-string],
      [The idea's body as plain text, `""` where it is empty — matchable and excerptable, but not renderable. @idea:idea-body-reference[`#idea-body`] is how you render one.],

      [`href`],
      [#type-string | #type-none],
      [Where the idea's minted page sits _from the page this was called on_. See @idea:idea-href-reference[`#idea-href`].],

      [`page`],
      [#type-string | #type-none],
      [The same page from the site root. See @idea:idea-path-reference[`#idea-path`].],

      [`created`], [#type-datetime | #type-none], [The idea's date.],
    )

    Three things are deliberately not here in bulk: the body as content, the
    backlink graph, and the tag values. The first would make every consumer a
    second transclusion engine; the second is the minted page's own business;
    the third can be a datetime or content, which a JSON index encodes as a
    silent blob. This list is a contract other packages are written against, so
    a field is added rather than changed.

    #reference(<tag-index-reference>, title: [`#tag-index`])[
      A declared projection of tag values onto an `#ideas` row. It exists
      because a tag's value is arbitrary and a row's fields must be encodable;
      a projection makes the value narrow and checked, which is what lets it
      ride a row at all.

      ```typ
      #import "@rookery/core:0.1.0": ideas, tag-index

      #let INDEX = tag-index((
        cycle: (family: "cycle-"),                      // -> "26-27"
        kind: (family: "venue-", one-of: KINDS),        // -> "postdoc"
        deadline: (key: "date-deadline", stamp: true),  // -> "20261101"
        stage: (from: stage-of),                        // derived
      ))

      #context {
        for e in ideas(index: INDEX) [- #e.kind, due #e.deadline]
      }
      ```

      Each field names exactly one extractor:

      #table(
        columns: (auto, 1fr),
        table.header([Form], [What it projects]),

        [`key: "<tag>"`], [That tag's value, or #type-none where the idea does not carry it.],

        [`family: "<prefix>"`],
        [The first flat tag whose key starts with the prefix, prefix stripped. `one-of:` restricts _and orders_ the candidates, so an idea carrying two of a family resolves to the earliest you listed rather than to whichever key order happens to yield first.],

        [`from: <function>`],
        [Called with the idea's whole tag dictionary. A derived value — the current stage of a dated log, how far something got — is a computation rather than a tag value, and this is the only form that makes one filterable or sortable.],
      )

      Any of the three may carry `stamp: true`, which renders a datetime as a
      zero-padded `[year][month][day]` string. That is not only a display
      choice: a fixed-width numeric string sorts lexically in date order, so a
      stamped field is a free sort key.

      A projected value must be a scalar — a string, an integer, a float, a
      boolean or #type-none — and the build fails where one is not. A field may
      not take the name of a row field above, for the same reason: naming one
      `href` and silently replacing every link on the page is the failure this
      refusal prevents.
    ]

    #reference(<tag-data-reference>, title: [`#tag-data`])[
      Every registered idea's tag dictionary, keyed by full name. The bulk
      accessor a package builds on when it needs tag _values_ across the whole
      rookery, where @idea:idea-tag-names-reference[`#idea-tag-names`] and
      @idea:idea-tag-value-reference[`#idea-tag-value`] answer for one idea at a time.

      ```typ
      #import "@rookery/core:0.1.0": ideas, tag-data
      #context {
        let tags = tag-data()
        // -> ("idea:etal": (phd: none, priority: 1), ..)
        for e in ideas() [- #e.label: #repr(tags.at(e.id))]
      }
      ```

      Takes no arguments, and must be called inside `#context`. One `#ideas` plus
      one `#tag-data` covers the corpus, and the two join on `id` — which is the
      point, since the per-idea accessors each resolve the registry again and
      walking a rookery through them pays that cost once per idea.

      Values are arbitrary Typst values: datetimes, arrays, content, whatever a
      package put there. Do not serialize this wholesale into a page.

      It is not called `tags()`, though that is the obvious parallel with
      `#ideas`: `tags` is a parameter name on `#idea`, `#ideate` and most of this
      package's constructors, so a bare `tags()` would be shadowed by that
      parameter inside every one of their bodies.
    ]
  ]

]
