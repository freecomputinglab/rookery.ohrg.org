default:
    @echo "rookery.ohrg.org: 'just watch' to live-rebuild, 'just build' for a one-shot"

fonts:
    mkdir -p build/html/fonts
    cp fonts/*.ttf build/html/fonts/

watch: fonts
    rheo watch . --open --html

build:
    rheo compile . --html
    just fonts

# Every `@rookery/core` and `@rookery/search` spec in the repo moves at
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
      -e "@rookery/core:{{OLD}}" -e "@rookery/search:{{OLD}}" . \
      | xargs -r sed -i \
        -e "s|@rookery/core:{{OLD}}|@rookery/core:{{NEW}}|g" \
        -e "s|@rookery/search:{{OLD}}|@rookery/search:{{NEW}}|g"
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
      '@rookery/core(-search)?:[0-9]+\.[0-9]+\.[0-9]+' . | sed 's/.*://' | sort -u)
    if [ "$(printf '%s\n' "$vers" | wc -l)" -ne 1 ]; then
      echo "@rookery/core specs disagree: $(printf '%s' "$vers" | tr '\n' ' ')" >&2
      grep -rnE --binary-files=without-match \
        --exclude-dir=build --exclude-dir=.jj --exclude-dir=.git --exclude-dir=.beads \
        '@rookery/core(-search)?:[0-9]+\.[0-9]+\.[0-9]+' . >&2
      exit 1
    fi
    echo "all @rookery/core specs at $vers"
