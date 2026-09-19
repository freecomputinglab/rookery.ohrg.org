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

#idea("rookery", title: [A rookery], tags: ("concept",), display-tags: true)[
  A rookery is a place where your ideas can grow.
  Rookeries are collections of files, entirely local and owned by you, with no vendor or cloud lock-in.
  When rookeries are compiled with #link("https://rheo.ohrg.org")[Rheo], every idea can be rendered as a webpage, a PDF, or an EPUB, at any time.
  This is true also for _collections_ of ideas, ranging from a set of ideas with the same @idea:tags[tags] to your entire rookery.

  #window((<getting-started>), folded: true)

  #idea("idea", title: [An idea], tags: ("concept",), display-tags: true)[
    An idea in a @idea:rookery[rookery] is written in #link("https://typst.app/")[Typst].
    Every idea can be referenced by any other idea or page in the same rookery.

    Each idea also gets a standalone page that will show its *context*---where it was first hatched---and its *backlinks*---the set of other ideas and pages that reference it---in its footer.
    Try clicking on this idea's name above (the `[idea:idea]` text), to see its standalone page as an example.

    Ideas can be hyperlinked to other ideas, or they can be interpolated as *windows* onto the original idea.
    Clicking on the title of a window will unfold the idea within your current context.
    Clicking on the idea's name will take you to the idea's standalone page.

    Try unfolding these windows below by clicking on their title panel to learn more.

    #window("hatching-ideas", folded: true)
    #window("referencing-ideas", folded: true)
  ]
]

This site is a rookery.
Everything you see here exemplifies rookery features such as @idea:windows[windows], @idea:hyperlinks[hyperlinks], and @idea:outlines[outlines].
