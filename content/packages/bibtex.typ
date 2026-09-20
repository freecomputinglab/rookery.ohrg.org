#set document(
  title: "Rookery - @rookery/bibtex",
  date: datetime(year: 2026, month: 8, day: 20),
)

#idea(<rookery-bibtex>, tag: "alpha-package", title: [`@rookery/bibtex`])[
  Reads a `.bib` file and mints one idea per reference, keyed and titled from the entry itself, so a citation is an idea like any other in the rookery.

  An `@article` keyed `okafor2019` becomes a note titled _Okafor, Latency Budgets for Interactive Systems (2019)_.
  Any other note reaches it as `@idea:okafor2019`.

  ```typ
  #import "@rookery/core:0.1.0": rookery
  #import "@rookery/bibtex:0.1.0": bibtex
  #show: rookery

  /* Export the .bib with macros expanded and accents as Unicode. The parser
     resolves neither @string nor LaTeX escapes. */
  #let refs = bibtex(read("references.bib"))

  /* One entry, with your own reading of it as the note's body. Typst cannot
     call a dictionary key directly, so the parentheses are the form. */
  #(refs.citation)("okafor2019")[
    Cited directly, because its accounting of responsiveness as a budget spent
    reframes what the rest of this bibliography treats as measured only after
    the fact.
  ]

  /* Every remaining entry, in key order. Call this once, from one page. A
     hand-written citation always wins over it for the same key. */
  #(refs.all)()
  ```

  == Showing the record

  Where a note wants to print a reference rather than point at it, ask for its fields.

  ```typ
  #(refs.fields)("okafor2019")
  ```
]
