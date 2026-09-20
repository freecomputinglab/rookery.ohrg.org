#set document(
  title: "Rookery - @rookery/bibtex",
  date: datetime(year: 2026, month: 8, day: 20),
)

#idea(<rookery-bibtex>, tag: "alpha-package", title: [`@rookery/bibtex`])[
  Reads a `.bib` file and mints one idea per reference, keyed and titled from the entry itself, so a work is a note like any other and anything that cites it says so with a backlink.

  Write a citation by hand where you have something to say about the work, and sweep the rest of the bibliography with `all()`.

  ```typ
  #import "@rookery/core:0.1.0": rookery
  #import "@rookery/bibtex:0.1.0": bibtex
  #show: rookery

  /* Typst cannot call a dictionary key directly, so bind the factory's
     functions once rather than writing #(refs.citation)(..) at every call. */
  #let refs = bibtex(read("references.bib"))
  #let citation = refs.citation
  #let citations-as-ideas = refs.all

  /* The BibTeX key names the note, written as a ref, a bare label or a string.
     The title comes off the entry as "Badiou, Ethics (2002)", and the note is
     tagged `citation` alongside whatever tags: you add. */
  #citation(<badiou2002>, tags: "essay")[
    Read against Handelman, since it treats the same refusal of mathematics as
    a question of ethics rather than of method.

    /* The entry's own fields, as a definition list. */
    #refs.fields("badiou2002")
  ]

  /* Every entry no hand-written citation has claimed, in key order. Call this
     once, from one vertebra — a register page the bar never lists, which the
     pages a reader browses transclude by tag. */
  #citations-as-ideas()
  ```

  == Reading a reference manager's export

  Zotero writes rows that belong to the library rather than to the work, and a library holds far more than a project cites.
  Narrow and trim at the factory, once.

  ```typ
  #let refs = bibtex(
    read("references.bib"),
    /* Parse these keys alone, so a fourteen-hundred-entry export costs what
       the project actually cites and mints as many notes. */
    only: ("badiou2002", "handelman2019"),
    /* Turn Zotero's own keywords into rookery tags, then hide the raw row
       they came from. */
    keywords: "all",
    show-fields: ("keywords": false, "urldate": false, "file": false),
  )
  ```
]
