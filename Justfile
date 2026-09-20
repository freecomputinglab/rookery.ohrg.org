default:
    @echo "rookery.ohrg.org: 'just watch' to live-rebuild, 'just build' for a one-shot"

watch:
    rheo watch . --open --html

build:
    rheo compile . --html

# Copies the licensed faces alongside the built HTML so `@font-face`'s
# `url('./fonts/...')` resolves. Run it after `build`, which writes the output
# tree fresh. CI calls this through `build.sh`, which fetches the TTFs from the
# private fonts repo first; locally it picks up whatever is already in `fonts/`.
# A no-op with a message when there are none, so it is safe to run on any clone.
fonts:
    #!/usr/bin/env bash
    set -euo pipefail
    if ! ls fonts/*.ttf >/dev/null 2>&1; then
        echo "fonts: no TTFs in fonts/ — the site renders in the system monospace fallback"
        exit 0
    fi
    mkdir -p build/html/fonts
    cp fonts/*.ttf build/html/fonts/
    echo "fonts: copied $(ls fonts/*.ttf | wc -l) face(s) into build/html/fonts/"
