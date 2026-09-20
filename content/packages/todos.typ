#set document(
  title: "Rookery - @rookery/todos",
  date: datetime(year: 2026, month: 8, day: 20),
)

#idea(<rookery-todos>, tag: "alpha-package", title: [`@rookery/todos`])[
  Writes todos and epics as ideas with a dependency graph over them, so a rookery can say for itself what is ready to work, what is blocked, and what has gone stale.

  A todo is an idea with a priority, a state and a list of the todos it waits on.
  Nothing computes what to do next, as the graph already knows.

  ```typ
  #import "@rookery/core:0.1.0": rookery
  #import "@rookery/todos:0.1.0": todo, todos-ready, todo-graph-view
  #show: rookery

  #let TODAY = datetime(year: 2026, month: 8, day: 25)

  /* Name any todo something else depends on. An auto-named #todo[..] takes a
     sequence id that shifts the moment a note is inserted earlier in the file,
     silently repointing every dependency on it. */
  #todo("fetch", title: [Fetch the source], priority: 0, done: datetime(year: 2026, month: 8, day: 1))[..]

  /* Priorities run the way birds' do, a higher number being more important with
     no ceiling, so escalating something never means renumbering everything
     below it. */
  #todo("parse", title: [Parse it], priority: 9, type: "bug", deps: ("fetch",))[..]

  /* parse waits on fetch, fetch is closed, so parse is what surfaces here.
     Every view needing a now takes today: explicitly and panics without one. */
  #todos-ready(today: TODAY)
  #todo-graph-view(today: TODAY)
  ```

  == Grouping todos into an epic

  An epic is a tag with a constructor bound to it rather than a container.
  Two todos in one epic stay unrelated until one names the other in `deps:`, as the epic groups them without ordering them.

  ```typ
  #let launch = epic("launch")
  #launch("plan", priority: 5)[Kick-off.]
  #launch("post", deps: ("plan",))[Follows the plan.]
  ```
]
