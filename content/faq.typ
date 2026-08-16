#import "template.typ": template
#import "@rheo/rookery:0.1.1": idea, ideas-outline, todo

#show: template.with(current-page: "faq")
#set document(title: "FAQ")

#ideas-outline()

#idea(<inspiration>, title: [What inspired rookery?])[
  Rookery builds on #link("https://www.ohrg.org/devonthink-part-iii")[thinking] #link("https://www.ohrg.org/devonthink-part-ii")[about] #link("https://www.ohrg.org/devonthink-part-i")[associative archiving] that dates back to 2019.
  Its name and metaphor system derive from thinking about #link("https://www.ohrg.org/birdkeeping")[software in the age of large language models].

  More generally as a knowledge management tool, rookery takes its cue from the #link("https://zettelkasten.de/overview/")[Zettelkasten method], which was popularized in 2019 by #link("https://en.wikipedia.org/wiki/Roam_(software)")[Roam Research], and which has since influenced both #link("https://obsidian.md/")[Obsidian] and #link("https://www.notion.com/")[Notion], two popular knowledge management platforms.

  Though closest in spirit to Obsidian in the sense that it allows you to create and manage a local-first knowledge base using markdown files on disk, Rookery is more opinionated than Obsidian and Notion, but less opinionated than strict Zettelkasten.

  Rookery takes more direct inspiration from three ways of thinking about note systems:
  + Andy Matsuchak's #link("https://notes.andymatuschak.org/z5E5QawiXCMbtNtupvxeoEX")[evergreen notes].
  + Jon Sterling's #link("https://www.forester-notes.org/QHXS/index.xml")[intellectual junkyards].
  + #link("https://orgmode.org/worg/org-tutorials/orgtutorial_dto.html")[Emacs' Org-mode].

  #idea(title: [What is the genealogy of `idea`?])[
    The semantics of an `idea` is taken from the default #link("https://docs.doomemacs.org/latest/")[Doom Emacs] #link("./.gitignore")[TODO keywords], one of which is `IDEA`.

    An idea in a rookery should be conceptualized as an #link("https://www.forester-notes.org/tfmt-0007/index.xml")[atomic note], which is why each idea is given its own standalone page.
    As with notes in other Zettelkasten-inspired systsems, ideas that link to each other #link(<idea:idea>)[produce backlinks]

    In addition to this sense of an idea (as a 'Zettel', or note), it can also be the basis for a 'todo' item (as an Org-mode TODO).
    This is one of the reasons that rookery ships the `#todo` function as syntactic sugar for an `#idea` with a `"todo"` tag.
    Though there is no inbuilt sense in which one idea can depend on or be blocked by another, you can create a stronger dependency system over tags, i.e. using a `blockedby:xxx` convention.
  ]

  #idea(<other-tools>, title: [What are other tools like rookery?])[
    Rookery was #link(<idea:inspiration>)[inspired by a range of existing knowledge management tools].
    The open source system most similar to rookery---and which chiefly inspired it---is probably #link("https://www.forester-notes.org/30FM/index.xml")[forester], an #link("https://sr.ht/~jonsterling/forester/")[OCaml engine] that Jon Sterling develops to power #link("https://www.jonmsterling.com/")[his website].
    A non-exhaustive list of the differences between forester and rookery:
    - Forester rolls its own #link("https://deepwiki.com/jonsterling/ocaml-forester/4-markup-language")[enchanced Markup language], whereas rookery uses Typst.
    - Forester requires an Opam/Ocaml toolchain and has a #link("https://www.forester-notes.org/013A/index.xml")[datalog-based query engine], whereas rookery needs only the #link("https://rheo.ohrg.org/getting-started")[cross-platform Rheo binary] as its #link("https://en.wikipedia.org/wiki/Transclusion")[transclusion] is powered by native Typst. Both produce standalone static sites.
    - Forester has #link("https://www.forester-notes.org/013A/index.xml")[thoughtful mechanisms] for federating multiple forests by way of #link("https://www.forester-notes.org/30FN/index.xml")[selective tree publication], whereas rookeries are conceived as standalone collections. (Federating rookeries is intended future work.)
    - Rookery can be incrementally adopted in an existing Rheo project---a 'normal' #link("https://rheo.ohrg.org/")[writing project or website] that isn't organized as atomic notes---by sprinkling `#idea` blocks in as they are concieved, whereas forester must be adopted wholesale.
  ]
]

#idea(<using-typst>, title: [Do I need to use Rheo to use rookery?])[
  #link("https://rheo.ohrg.org/")[Rheo] is a typesetting engine based on Typst that is also maintained at the #link("https://freecomputinglab.ohrg.org/")[Free Computing Lab].
  In addition to providing an EPUB export option, Rheo can also #link("https://rheo.ohrg.org/packages")[register custom JavaScript and CSS from a package] such as rookery.

  While we make a best-effort to keep the rookery package Typst-native, we can guarantee a better experience if you compile your rookeries with Rheo.
  A large part of this is because rookery's implementation depends heavily on #link("https://typst.app/docs/reference/bundle/")[Typst's experimental bundle export], which means that one needs various flags and specific configuration to compile a rookery with the Typst CLI.
  Using Rheo, by contrast, rookery should work out of the box.
]


#idea(<maintenance>, title: [Who maintains rookery?])[
  Rookery is tooling maintained as part of the #link("https://freecomputinglab.ohrg.org/")[Free Computing Lab], an association of academics who have no strict affiliation with any company.
  The tool was originally built by #link("https://lachlankermode.com/")[Lachlan Kermode] as a way to organize his #link("https://weeknotes.ohrg.org/")[research weeknotes].
  #link("https://rheo.ohrg.org/")[Rheo] is also built and maintained by the Free Computing Lab.
]
