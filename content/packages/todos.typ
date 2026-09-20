#set document(
  title: "Rookery - @rookery/todos",
  date: datetime(year: 2026, month: 9, day: 19),
)

#idea(<rookery-todos>, tag: "alpha-package", title: [`@rookery/todos`])[
  The `todos` package writes todos and epics as ideas with a dependency graph over them, so that a rookery can say for itself what is ready to work, what is blocked, and what has gone stale.

  A todo is an idea with a priority, a state and a list of the todos it waits on.
  Nothing computes what to do next — the graph does:

  ```typ
  #import "@rookery/core:0.1.0": rookery
  #import "@rookery/todos:0.1.0": todo, todos-ready, todo-graph-view
  #show: rookery

  #let TODAY = datetime(year: 2026, month: 8, day: 25)

  #todo("fetch", title: [Fetch the source], priority: 0, done: datetime(year: 2026, month: 8, day: 1))[..]
  #todo("parse", title: [Parse it], priority: 9, type: "bug", deps: ("fetch",))[..]

  #todos-ready(today: TODAY)
  #todo-graph-view(today: TODAY)
  ```

  `parse` waits on `fetch`, `fetch` is closed, so `parse` is what
  `#todos-ready` surfaces. Priorities run the way birds' do — a higher number is
  more important, with no ceiling — so escalating something never means
  renumbering everything below it.

  An epic is a tag with a constructor bound to it rather than a container:

  ```typ
  #let launch = epic("launch")
  #launch("plan", priority: 5)[Kick-off.]
  #launch("post", deps: ("plan",))[Follows the plan.]
  ```

  Two todos in one epic are unrelated until one names the other in `deps:` — the
  epic groups them, it does not order them. Name any todo something else depends
  on: an auto-named `#todo[..]` takes a sequence id that shifts the moment a note
  is inserted earlier in the file, which silently repoints every dependency on
  it. Every view needing a "now" takes `today:` explicitly and panics without
  one.
]
