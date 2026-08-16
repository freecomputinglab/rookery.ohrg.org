default:
    @echo "rookery.ohrg.org: 'just watch' to live-rebuild, 'just build' for a one-shot"

# `@rheo/rookery:0.1.0` and `@rheo/rookery-search:0.1.0` are fetched from the
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
# private digitaltheorylab/fonts repo with FONTS_GITHUB_TOKEN, and a fresh
# clone needs them dropped into `fonts/` by hand before this recipe works.
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
