# rookery.ohrg.org

Documentation site for [`@rookery/core`](https://github.com/freecomputinglab/rookery),
built with [Rheo](https://rheo.ohrg.org) — and written with rookery.

## Getting started 

With [Rheo installed](https://rheo.ohrg.org/getting-started), run:

```sh
just watch   # live-rebuild and open
just build   # one-shot HTML into build/html/
```

Note that `rheo.toml`'s `[packages.rookery]` table pins `@rookery/core` to a remote
repository and branch.
So as not to be affected by breakages in development, set it to releases:

```toml
[packages.rookery]
releases = "freecomputinglab/rookery"
```


