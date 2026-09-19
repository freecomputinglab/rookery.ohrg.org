#import "template.typ": template
#import "@rookery/core:0.1.0": footnote, idea, ideas-outline, window

#show: template.with(current-page: "packages")
#set document(
  title: "Rookery - Packages",
  date: datetime(year: 2026, month: 9, day: 19),
)

#let core = idea.with(tag: "@rookery/core")

#let type-string = link("https://typst.app/docs/reference/foundations/str/")[str]
#let type-label = link("https://typst.app/docs/reference/foundations/label/")[label]
#let type-content = link("https://typst.app/docs/reference/foundations/content/")[content]
#let type-int = link("https://typst.app/docs/reference/foundations/int/")[int]
#let type-bool = link("https://typst.app/docs/reference/foundations/bool/")[bool]
#let type-array = link("https://typst.app/docs/reference/foundations/array/")[array]
#let type-dict = link("https://typst.app/docs/reference/foundations/dictionary/")[dictionary]
#let type-datetime = link("https://typst.app/docs/reference/foundations/datetime/")[datetime]
#let type-auto = link("https://typst.app/docs/reference/foundations/auto/")[auto]
#let type-none = link("https://typst.app/docs/reference/foundations/none/")[none]
#let type-function = link("https://typst.app/docs/reference/foundations/function/")[function]

#core(<rookery-core>, title: [`@rookery/core`])[
  The `core` package in rookery provides the @idea:core-idea and @idea:core-ideate functions.
  These functions are the foundational concepts on which all other #link(<packages>)[rookery packages] are constructed.

  #core(<core-idea>, title: [`#idea`])[
    For an intuition on how to think about ideas, see @idea:idea.
    The `#idea` function takes the following arguments, which are all optional:

    #table(
      columns: (auto, auto, auto),
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
      [The seven `display-*` flags below as a single dictionary, with the prefix dropped — `display: (frame: false, tags: true)`. An individual `display-*` argument on the same call wins over the dictionary's value for that key.],

      [`display-title`],
      [#type-bool | #type-auto],
      [Whether the idea's own minted page carries its title as an `<h1>`. Nowhere else the title appears is affected.],

      [`display-date`],
      [#type-bool | #type-auto],
      [Whether the idea's `created` date is shown at the right-hand end of its hat. The date is always recorded either way.],

      [`display-tags`],
      [#type-bool | #type-auto],
      [Whether the idea's tags are shown in its hat as pills. Only plain tags are rendered; a tag carrying metadata is left to the package that gave it meaning.],

      [`display-frame`],
      [#type-bool | #type-auto],
      [Whether the idea is drawn as a card, with the left rule and indent that go with it. Turning it off changes nothing else: the idea still registers, still wears its tags, and still renders its hat and body.],

      [`display-id`],
      [#type-bool | #type-auto],
      [Whether the idea's id is shown in its hat as a permalink. This is the only way to discover the id of an idea that was given neither a name nor a title.],

      [`display-context`],
      [#type-bool | #type-auto],
      [Whether the idea's minted page footer links back to the page the idea was written on.],

      [`display-backlinks`],
      [#type-bool | #type-auto],
      [Whether the idea's minted page footer lists every idea and page that links to it.],
    )

    Each `display-*` argument defaults to #type-auto, meaning the rookery-wide
    setting given to `#rookery(display: ..)` — an idea states an opinion only
    where it differs from the rest of the rookery.
  ]

  #core(<core-ideate>, title: [`#ideate`])[
    The one place in rookery where an idea is _inferred_ rather than written.
    `#ideate` takes a block of content and mints ideas from it, either as a
    plain function on one block or as a document show rule — `#show: ideate`
    at the top level hands it the rest of the document. It is opt-in either
    way, and on a paged target it is a passthrough: a PDF of a block of prose
    is that block of prose.

    #table(
      columns: (auto, auto, auto),
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
      [As on @idea:core-idea[`#idea`], and read by every idea minted.],

      [`display-frame`],
      [#type-bool],
      [Whether each minted idea is drawn as a card. Defaults to `false`, inverting `#idea`'s own default: an inferred idea is not one anybody named, and a frame around every paragraph is chrome nobody asked for.],

      [`display-id`],
      [#type-bool],
      [Whether each minted idea wears its id as a permalink. Defaults to `false` for the same reason, and with more force: an inferred idea's id is a sequence number, which tells a reader nothing.],
    )

    Every other `#idea` argument is forwarded to every idea minted. Note that
    those ids are generated rather than authored, so an idea that has to be
    linkable is written by hand.
  ]

]


#idea(<rookery-search>, title: [`@rookery/search`])[]
#idea(<rookery-timeline>, title: [`@rookery/timeline`])[]
#idea(<rookery-todos>, title: [`@rookery/todos`])[]
#idea(<rookery-cfps>, title: [`@rookery/cfps`])[]
#idea(<rookery-bibtex>, title: [`@rookery/bibtex`])[]
#idea(<rookery-slipshow>, title: [`@rookery/slipshow`])[]
#idea(<rookery-pinboard>, title: [`@rookery/pinboard`])[]


