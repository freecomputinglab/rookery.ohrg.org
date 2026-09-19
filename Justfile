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
