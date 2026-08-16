#!/bin/bash
set -e  # Exit on error
set -x  # Print commands for debugging

echo "=== Starting build ==="
echo "Timestamp: $(date)"

# Setup paths
REPO_DIR="$(pwd)"
RHEO_VERSION="v$(grep '^version' "$REPO_DIR/rheo.toml" | sed 's/version = "\(.*\)"/\1/')"
RHEO_CACHE="$REPO_DIR/.rheo-binary"
RHEO_BIN="$RHEO_CACHE/rheo"

# Download rheo binary from GitHub release if not cached
if [ ! -f "$RHEO_BIN" ]; then
  echo "Downloading rheo ${RHEO_VERSION}..."
  mkdir -p "$RHEO_CACHE"
  curl -sL "https://github.com/freecomputinglab/rheo/releases/download/${RHEO_VERSION}/rheo-x86_64-unknown-linux-gnu.zip" -o /tmp/rheo.zip
  unzip -o /tmp/rheo.zip -d "$RHEO_CACHE"
  chmod +x "$RHEO_BIN"
  rm /tmp/rheo.zip
  echo "Rheo downloaded successfully"
else
  echo "Using cached rheo binary"
fi

# Add rheo to PATH
export PATH="$RHEO_CACHE:$PATH"

# Verify rheo is accessible
rheo --version || echo "Warning: rheo --version failed, but continuing..."

# `@rheo/rookery` and `@rheo/rookery-search` are fetched from the rheo-packages
# GitHub releases by the rheo CLI itself, so there is nothing to clone or build
# here — the versions in `content/template.typ` are what CI resolves.

# Berkeley Mono is licensed, so the TTFs are gitignored rather than committed.
# CI pulls them from the private fonts repo with FONTS_GITHUB_TOKEN; locally
# they are already sitting in `fonts/`.
if [ -n "${FONTS_GITHUB_TOKEN}" ]; then
  echo "Downloading fonts from private repository..."
  mkdir -p fonts
  FONT_FILES=(
    "BerkeleyMono-Regular.ttf"
    "BerkeleyMono-Bold.ttf"
    "BerkeleyMono-Oblique.ttf"
    "BerkeleyMono-Bold-Oblique.ttf"
  )
  for font in "${FONT_FILES[@]}"; do
    curl -fsSL \
      -H "Authorization: Bearer ${FONTS_GITHUB_TOKEN}" \
      -H "Accept: application/vnd.github.raw+json" \
      "https://api.github.com/repos/digitaltheorylab/fonts/contents/${font}" \
      -o "fonts/${font}"
    echo "Downloaded: ${font}"
  done
  echo "Fonts downloaded successfully"
else
  echo "FONTS_GITHUB_TOKEN not set; using fonts from working directory"
fi

# Compile the site
echo "Compiling with rheo..."
rheo compile . --html

# Copy fonts alongside the built HTML so @font-face url('./fonts/...') resolves.
# rheo copies no static directories — `css_stylesheet` is its only html asset
# key — so this is a plain copy, the same one `just fonts` makes locally. Must
# run after the compile, which writes the tree fresh. Skipped when absent, so a
# tokenless build still produces a site, in the generic monospace fallback.
if ls fonts/*.ttf >/dev/null 2>&1; then
  echo "Copying fonts into build/html/fonts/..."
  mkdir -p build/html/fonts
  cp fonts/*.ttf build/html/fonts/
else
  echo "No font TTFs present; site renders with system monospace fallback"
fi

# Verify output was generated
if [ ! -f "build/html/index.html" ]; then
  echo "Error: build/html/index.html not found after compilation"
  exit 1
fi

# Count generated HTML files
HTML_COUNT=$(find build/html -name "*.html" | wc -l)
echo "Successfully generated $HTML_COUNT HTML files"

echo "=== Build completed successfully ==="
echo "Timestamp: $(date)"
