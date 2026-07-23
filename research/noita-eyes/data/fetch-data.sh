#!/usr/bin/env bash
# Fetch canonical Noita eye-message research data.
# Run from a machine with normal network access (the CI/agent sandbox blocks
# these hosts). Clones go to ./external/ which is gitignored.
set -euo pipefail

cd "$(dirname "$0")"
mkdir -p external

repos=(
  "https://github.com/codewarrior0/noita-eye-glyph-analyses"
  "https://github.com/SirCapybar/NoitaEyeGlyphResearch"
  "https://github.com/ngraham20/NoitaCryptographyResearch"
)

for url in "${repos[@]}"; do
  name=$(basename "$url")
  if [ -d "external/$name/.git" ]; then
    git -C "external/$name" pull --ff-only
  else
    git clone --depth 1 "$url" "external/$name"
  fi
done

echo
echo "Cloned research repos into $(pwd)/external/."
echo "Locate the trigram transcriptions (look for csv/txt data files, e.g.:"
find external -maxdepth 3 -iname '*.csv' -o -iname '*trigram*' -o -iname '*message*' 2>/dev/null | sed 's/^/  /' | head -40
echo ") and convert to ./messages.txt per README.md, then run:"
echo "  python ../tools/eyes_analysis.py --data messages.txt validate"
