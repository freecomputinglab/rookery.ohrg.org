#set document(
  title: "Rookery - @rookery/bibtex",
  date: datetime(year: 2026, month: 8, day: 20),
)

#idea(<rookery-bibtex>, tag: "alpha-package", title: [`@rookery/bibtex`])[
  The `bibtex` package reads a `.bib` file and mints one idea per reference, titled and keyed from the entry itself, so that a citation is an idea like any other in the rookery.

  Read the file once, then mint from it — by hand where you have something to say
  about a reference, and in bulk for everything else:

  ```typ
  #import "@rookery/core:0.1.0": rookery
  #import "@rookery/bibtex:0.1.0": bibtex
  #show: rookery

  #let refs = bibtex(read("references.bib"))

  // One entry, with your own reading of it as the note's body.
  #(refs.citation)("okafor2019")[
    Cited directly, because its accounting of responsiveness as a budget spent
    reframes what the rest of this bibliography treats as measured only after
    the fact.
  ]

  // Every remaining entry, minted once, in key order.
  #(refs.all)()
  ```

  Given the entry

  ```bibtex
  @article{okafor2019,
    title = {Latency Budgets for Interactive Systems},
    author = {Okafor, Chidi},
    journal = {Journal of Systems Research},
    year = {2019},
  }
  ```

  the note is titled _Okafor, Latency Budgets for Interactive Systems (2019)_ and
  named for the key, so any other note reaches it as `@idea:okafor2019` — the
  reference is a destination in the rookery rather than a row in a list at the
  end of a document. `#(refs.fields)("okafor2019")` prints the record itself
  where a note wants to show it rather than point at it.

  The parentheses around `refs.citation` are not decoration: Typst cannot call a
  dictionary key directly, so `#refs.citation(..)` fails to compile and
  `#(refs.citation)(..)` is the form. `all()` mints the whole bibliography and so
  must be called once, from one page; a hand-written `citation` always wins over
  it for the same key, whichever was written first. The parser wants a `.bib`
  exported with macros already expanded and accents as Unicode — it resolves
  neither `@string` nor LaTeX escapes.
]
