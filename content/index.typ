#import "template.typ": template
#import "@rookery/core:0.1.0": footnote, idea, window

#show: template.with(current-page: "index")
#set document(
  title: "Rookery - Homepage",
  date: datetime(year: 2026, month: 8, day: 20),
)

#context if target() == "html" {
  html.elem("div", attrs: (class: "hero"))[
    #image("img/rookery-banner.png", alt: "Rookery")
  ]
} else {
  image("img/rookery-banner.png", alt: "Rookery")
}

#idea("rookery", title: [A rookery], tags: ("concept",), show-tags: true)[
  A rookery is a place where your ideas can grow.
  Rookeries are collections of files, entirely local and owned by you, with no vendor or cloud lock-in.
  When rookeries are compiled with #link("https://rheo.ohrg.org")[Rheo], every idea can be rendered as a webpage, a PDF, or an EPUB, at any time.
  This is true also for _collections_ of ideas, ranging from a set of associated ideas to your entire rookery.

  Get started building your own rookery today:

  #window((<installing>), folded: false)

  #idea("idea", title: [An idea], tags: ("concept",), show-tags: true)[
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
]

This site is a rookery.
Everything you see here exemplifies rookery features such as @idea:windows[windows], @idea:hyperlinks[hyperlinks], and @idea:outlining[outlining].
