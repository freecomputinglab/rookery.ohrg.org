#set document(
  title: "Rookery - Packages",
  date: datetime(year: 2026, month: 9, day: 19),
)

#idea(<alpha-packages>)[

  The following packages are alpha software, and thus subject to API breakages, bugs, and unlikely behavior.
  *Use them at your own risk!*

  In order to take this risk, you need to update your Rheo project to use rookery's `dev` branch:

  ```toml
  [packages.rookery]
  repo = "https://github.com/freecomputinglab/rookery"
  branch = "dev"
  ```
  // THE SHELF IS THE TAG, not a list of names: every package stub carries
  // `tag: "alpha-package"`, and this window selects on it. A package added under
  // `content/packages/` joins the shelf by tagging itself, and a package that
  // leaves alpha drops off it by dropping the tag — neither edits this page.
  //
  // `limit: 1` shows each stub's first block only, which is the one-sentence
  // overview those pages are written to lead with.
  //
  // Tag selection sorts by id, so the shelf reads alphabetically rather than in
  // whatever order the names were once typed here.
  #window(tagged: "alpha-package", limit: 1)
]

