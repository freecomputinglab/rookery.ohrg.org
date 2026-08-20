#import "template.typ": template
#import "@rheo/rookery:0.4.0": footnote, idea, ideas-outline, todo

#show: template.with(current-page: "faq")
#set document(
  title: "FAQ",
  date: datetime(year: 2026, month: 8, day: 20),
)

// `show-tags: true` by default, as on the other pages: the kind shows as a
// coloured pill in the hat, from `TAG-COLORS` in template.typ.
#let faq(tags: (), show-tags: true, ..args) = idea(
  tags: (("faq",) + tags),
  show-tags: show-tags,
  ..args,
)
#ideas-outline()

#faq(<inspiration>, title: [What inspired rookery?])[
  Rookery builds on #link("https://www.ohrg.org/devonthink-part-iii")[thinking] #link("https://www.ohrg.org/devonthink-part-ii")[about] #link("https://www.ohrg.org/devonthink-part-i")[associative archiving] that dates back to 2019.
  Its name and metaphor system derive from thinking about #link("https://www.ohrg.org/birdkeeping")[software in the age of large language models].

  More generally as a knowledge management tool, rookery takes its cue from the #link("https://zettelkasten.de/overview/")[Zettelkasten method], which was popularized in 2019 by #link("https://en.wikipedia.org/wiki/Roam_(software)")[Roam Research], and which has since influenced both #link("https://obsidian.md/")[Obsidian] and #link("https://www.notion.com/")[Notion], two popular knowledge management platforms.

  Of these tools, rookery is closest in spirit to Obsidian in the sense that it allows you to create and manage a local-first knowledge base using up files on disk.
  But you do not need to use a specific editor to write your rookeries; you can author the #link("https://typst.app/")[Typst] files in it however you prefer.
  Another way of thinking about rookery is that it is _more_ opinionated than Obsidian and Notion in that it requires you to think with @idea:idea[ideas].
  To some degree, it is also _less_ opinionated than Zettelkasten in that it doesn't enforce or require strictly atomic notes.

  Three ways of thinking about note systems have directly influenced rookery's design:
  + Andy Matsuchak's #link("https://notes.andymatuschak.org/z5E5QawiXCMbtNtupvxeoEX")[evergreen notes].
  + Jon Sterling's #link("https://www.forester-notes.org/QHXS/index.xml")[intellectual junkyards].
  + #link("https://orgmode.org/worg/org-tutorials/orgtutorial_dto.html")[Emacs' Org-mode].

  #faq(title: [What is the genealogy of `idea`?])[
    The semantics of an `idea` is taken from the default #link("https://docs.doomemacs.org/latest/")[Doom Emacs] #link("./.gitignore")[TODO keywords], one of which is `IDEA`.

    An idea in a rookery should be conceptualized as an #link("https://www.forester-notes.org/tfmt-0007/index.xml")[atomic note], which is why each idea is given its own standalone page.
    As with notes in other Zettelkasten-inspired systsems, ideas that link to each other #link(<idea:idea>)[produce backlinks]

    In addition to this sense of an idea (as a 'Zettel', or note), it can also be the basis for a 'todo' item (as an Org-mode TODO).
    This is one of the reasons that rookery ships the `#todo` function as syntactic sugar for an `#idea` with a `"todo"` tag.
    Though there is no inbuilt sense in which one idea can depend on or be blocked by another, you can create a stronger dependency system over tags, i.e. using a `blockedby:xxx` convention.
  ]

  #faq(<other-tools>, title: [What are other tools like rookery?])[
    Rookery was #link(<idea:inspiration>)[inspired by a range of existing knowledge management tools].

    #faq(<forester-rookery>, title: [Forester | Rookery])[

      #link("https://www.forester-notes.org/30FM/index.xml")[Forester] is the open source system most similar to rookery, and also its chief inspiration.
      Forester is an #link("https://sr.ht/~jonsterling/forester/")[OCaml engine] that Jon Sterling develops to power #link("https://www.jonmsterling.com/")[his website].
      It is not wrong to think about rookery as forester reimplemented for and in Typst.

      Both rookery and forester have:
      - Atomic notes with unique and stable IDs (ideas and trees, respectively)
      - Bidirectional linking and #link("https://en.wikipedia.org/wiki/Transclusion")[transclusion], which is a fancy word meaning that you can embed one note in another as a @idea:windows[window].
      - Compilation to a standalone static site.

      The core differences between forester and rookery:
      - Forester rolls its own #link("https://deepwiki.com/jonsterling/ocaml-forester/4-markup-language")[enchanced Markup language], whereas rookery uses Typst. This has consequences for how hyperlinks, mathematical markup, footnotes, citations, and inline code blocks are specified.
      - Forester requires an Opam/Ocaml toolchain and has a #link("https://www.forester-notes.org/013A/index.xml")[datalog-based query engine], whereas rookery is written in pure Typst.#footnote[We recommend compiling rookeries with #link("https://rheo.ohrg.org/getting-started")[Rheo] for a better experience, but it is @idea:using-typst[not strictly required].] Both produce standalone static sites.
      // - Forester has #link("https://www.forester-notes.org/013A/index.xml")[thoughtful mechanisms] for federating multiple forests by way of #link("https://www.forester-notes.org/30FN/index.xml")[selective tree publication], whereas rookeries are conceived as standalone collections. (Federating rookeries is intended future work.)
      - Rookery can be incrementally adopted in an existing Rheo project---a 'normal' #link("https://rheo.ohrg.org/")[writing project or website] that isn't organized as atomic notes---by sprinkling `#idea` blocks in as they are concieved, whereas forester must be adopted wholesale.
      - In addition to HTML and PDF, rookery can export to EPUB.
      - Rookery allows you to specify human-readable, semantic IDs to ideas if you prefer not to use sequential codes.
      - Forester was first released in 2023 and its latest major version, 5.0, was released in July 2025. Rookery is a pre-release software (version 0.`x`) that was announced in August 2026.
    ]

    #faq(<kodama-rookery>, title: [Kodama | Rookery])[

      #link("https://kodama-community.github.io/")[Kodama] is another forester-inspired tool for authoring #link("https://www.forester-notes.org/QHXS/index.xml")[intellectual junkyards] in Typst.

      - Rookery produces HTML, PDF, and/or EPUB, whereas Kodama renders only HTML.
      - Kodama does not explictly support transclusion with @idea:windows[windows], idea-scoped @idea:footnotes[footnotes] or @idea:citations[citations], @idea:hatching-ideas[tags to organize ideas], mobile viewing, or standalone pages for each idea.
      - Kodama requires a separate binary to compile in addition to Typst, whereas rookery needs only the Typst toolchain (or @idea:using-typst[Rheo as the preferred interface to it]).
      - Kodama allows you to write your notes in either Markdown or Typst, whereas rookery is pure Typst.
    ]
  ]
]

#faq(<using-typst>, title: [Do I need to use Rheo to use rookery?])[
  #link("https://rheo.ohrg.org/")[Rheo] is a typesetting engine based on Typst that is also maintained at the #link("https://freecomputinglab.ohrg.org/")[Free Computing Lab].
  In addition to providing an EPUB export option, Rheo can also #link("https://rheo.ohrg.org/packages")[register custom JavaScript and CSS from a package] such as rookery.

  While we make a best-effort to keep the rookery package Typst-native, we can guarantee a better experience if you compile your rookeries with Rheo.
  A large part of this is because rookery's implementation depends heavily on #link("https://typst.app/docs/reference/bundle/")[Typst's experimental bundle export], which means that one needs various flags and specific configuration to compile a rookery with the Typst CLI.
  Using Rheo, by contrast, rookery should work out of the box.
]


#faq(<maintenance>, title: [Who maintains rookery?])[
  Rookery is tooling maintained as part of the #link("https://freecomputinglab.ohrg.org/")[Free Computing Lab], an association of academics who have no strict affiliation with any company.
  The tool was originally built by #link("https://lachlankermode.com/")[Lachlan Kermode] as a way to organize his #link("https://weeknotes.ohrg.org/")[research weeknotes].
  #link("https://rheo.ohrg.org/")[Rheo] is also built and maintained by the Free Computing Lab.
]
