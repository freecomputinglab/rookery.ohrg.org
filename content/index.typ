#import "template.typ": template
#import "@rheo/rookery:0.1.0": footnote, idea, note, todo, window

#show: template.with(current-page: "index")
#set document(
  title: "Homepage",
  date: datetime(year: 2026, month: 8, day: 15),
)

#context if target() == "html" {
  html.elem("div", attrs: (class: "hero"))[
    #image("img/rookery-banner.png", alt: "Rookery")
  ]
} else {
  image("img/rookery-banner.png", alt: "Rookery")
}

#idea("rookery", title: [A rookery])[
  A rookery is a place where your ideas can grow.
  Rookeries are collections of files, entirely local and owned by you, with no vendor or cloud lock-in.
  When rookeries are compiled with #link("https://rheo.ohrg.org")[Rheo], every idea can be rendered as a webpage, a PDF, or an EPUB, at any time.
  This is true also for _collections_ of ideas, ranging from a set of associated notes to your entire rookery.

  #idea("idea", title: [An idea])[
    An idea in a @idea:rookery[rookery] is written in #link("https://typst.app/")[Typst].
    Every idea can be referenced by any other idea or page in the same rookery.

    Each idea also gets a standalone page that will show its *context*---where it was first hatched---and its *backlinks*---the set of other ideas and pages that reference it---in its footer.
    Try clicking on this idea's ID above (the `[idea:idea]` text), to see its standalone page as an example.

    Ideas can be hyperlinked to other ideas, or they can be interpolated as *windows* onto the original idea.
    Clicking on the title of a window will unfold the idea within your current context.
    Clicking on the idea's ID will take you to the idea's standalone page.

    Try unfolding these windows below by clicking on their title panel to learn more.

    #window("hatching-ideas", folded: true)
    #window("referencing-ideas", folded: true)
  ]

  You can get started building your own rookery today:

  #window((<installing>, <configuring>), folded: true)
]

This site is written with rookery, and built with Rheo.#footnote[Which makes it the worked example for everything described here: every window, backlink and standalone page on this site is the package doing its own job. This footnote sits outside any idea, so it behaves as Typst's own does --- numbered across the page, and collected at the bottom of it, rather than in an idea's Footnotes block.]



