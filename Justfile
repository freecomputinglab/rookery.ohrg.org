default:
    @echo "rookery.ohrg.org: 'just watch' to live-rebuild, 'just build' for a one-shot"

# `@rheo/rookery:0.1.0` must be resolvable from the Typst package cache or rheo
# fails with "package not found". On this machine the whole rheo-packages repo
# is symlinked in as the `rheo` namespace:
#
#     ln -sfnT ~/code/_rheo/rheo-packages ~/.cache/typst/packages/rheo
#
# so edits to `rookery/0.1.0/src/` show up here on the next rebuild with no
# publish step — the package is pure Typst and has no `dist/`.

# Berkeley Mono, into the output next to the stylesheet that asks for it.
# rheo copies no static directories — `css_stylesheet` is its only html asset
# key — so this is a plain copy, the same one cftw.ohrg.org's build.sh makes.
# Headers fall back to the generic `monospace` until it has run.
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
