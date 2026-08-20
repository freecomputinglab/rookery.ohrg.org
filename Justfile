default:
    @echo "rookery.ohrg.org: 'just watch' to live-rebuild, 'just build' for a one-shot"

# `@rheo/rookery:0.4.0` and `@rheo/rookery-search:0.4.0` are fetched from the
# rheo-packages GitHub releases into the Typst package cache, by rheo itself —
# nothing to install. To iterate on a package's source instead of the published
# tarball, displace the cached copy with a symlink to the working tree:
#
#     rm -rf ~/.cache/typst/packages/rheo/rookery
#     ln -sfnT ~/code/_rheo/rheo-packages/rookery ~/.cache/typst/packages/rheo/rookery
#
# rookery is pure Typst, so its `src/` edits land on the next rebuild;
# rookery-search needs `just build` in the package first, to refresh `dist/`.

# Berkeley Mono, into the output next to the stylesheet that asks for it.
# rheo copies no static directories — `css_stylesheet` is its only html asset
# key — so this is a plain copy, the same one cftw.ohrg.org's build.sh makes.
# Headers fall back to the generic `monospace` until it has run.
#
# The TTFs are licensed and therefore gitignored: CI pulls them from the
# private breezykermo/fonts repo with FONTS_GITHUB_TOKEN, and a fresh clone
# needs them dropped into `fonts/` by hand before this recipe works.
fonts:
    mkdir -p build/html/fonts
    cp fonts/*.ttf build/html/fonts/

# `rheo watch` rebuilds into the same tree without clearing it, so copying the
# fonts once up front is enough for a whole session.
watch: fonts
    rheo watch . --open --html

build:
    rheo compile . --html
    just fonts

# Every `@rheo/rookery` and `@rheo/rookery-search` spec in the repo moves at
# once — the seven executable imports and the fifteen inside ```typ blocks
# alike. The example blocks are deliberately NOT hidden behind a shared imports
# module: they teach a reader what to type, so each has to name a real
# published version rather than a site-local re-export.
#
# Only run this once the release is actually cut in rheo-packages. Locally the
# namespace symlink resolves any version directory that exists in that
# checkout, so a local build passes while CI, which downloads release archives,
# would 404.
#
# `.beads` is excluded because issue prose quotes old specs by design, and a
# machine-local tracker has no business failing the site's own check.
bump-deps OLD NEW:
    #!/usr/bin/env bash
    set -euo pipefail
    grep -rl --binary-files=without-match \
      --exclude-dir=build --exclude-dir=.jj --exclude-dir=.git --exclude-dir=.beads \
      -e "@rheo/rookery:{{OLD}}" -e "@rheo/rookery-search:{{OLD}}" . \
      | xargs -r sed -i \
        -e "s|@rheo/rookery:{{OLD}}|@rheo/rookery:{{NEW}}|g" \
        -e "s|@rheo/rookery-search:{{OLD}}|@rheo/rookery-search:{{NEW}}|g"
    just check-deps

# The standing guard — `rheo-packages`' `just check-versions` in this repo's
# shape. One version of each package across the tree, or a failure naming every
# place that disagrees. A stale spec inside a ```typ block compiles perfectly
# well and is wrong only for the reader, so nothing else catches it.
check-deps:
    #!/usr/bin/env bash
    set -euo pipefail
    vers=$(grep -rhEo --binary-files=without-match \
      --exclude-dir=build --exclude-dir=.jj --exclude-dir=.git --exclude-dir=.beads \
      '@rheo/rookery(-search)?:[0-9]+\.[0-9]+\.[0-9]+' . | sed 's/.*://' | sort -u)
    if [ "$(printf '%s\n' "$vers" | wc -l)" -ne 1 ]; then
      echo "@rheo/rookery specs disagree: $(printf '%s' "$vers" | tr '\n' ' ')" >&2
      grep -rnE --binary-files=without-match \
        --exclude-dir=build --exclude-dir=.jj --exclude-dir=.git --exclude-dir=.beads \
        '@rheo/rookery(-search)?:[0-9]+\.[0-9]+\.[0-9]+' . >&2
      exit 1
    fi
    echo "all @rheo/rookery specs at $vers"
