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
watch:
    rheo watch . --open --html

build:
    rheo compile . --html
