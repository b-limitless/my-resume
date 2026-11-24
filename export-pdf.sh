#!/usr/bin/env bash
# Usage: ./export-pdf.sh [input.md]  -> writes input.pdf next to it
set -euo pipefail

INPUT="${1:-resume-2026.md}"
OUTPUT="${INPUT%.md}.pdf"
HTML="$(mktemp -t resume).html"
CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"

BODY="$(npx -y marked@12 -i "$INPUT")"

cat > "$HTML" <<EOF
<!doctype html>
<html><head><meta charset="utf-8">
<style>
  @page { size: A4; margin: 12mm 14mm; }
  body { font-family: -apple-system, "Helvetica Neue", Arial, sans-serif;
         font-size: 9.5pt; line-height: 1.32; color: #111; }
  h1 { font-size: 20pt; margin: 0 0 2px; }
  h2 { font-size: 12pt; margin: 14px 0 4px; text-transform: uppercase;
       letter-spacing: .5px; border-bottom: 1px solid #ccc; padding-bottom: 2px; }
  h3 { font-size: 10.5pt; margin: 10px 0 0; }
  p { margin: 3px 0; }
  ul { margin: 3px 0; padding-left: 16px; }
  li { margin: 1px 0; }
  hr { display: none; }
  a { color: #111; text-decoration: none; }
  h3, h3 + p { break-after: avoid; }
  li { break-inside: avoid; }
</style></head>
<body>$BODY</body></html>
EOF

"$CHROME" --headless --disable-gpu --no-pdf-header-footer \
  --print-to-pdf="$PWD/$OUTPUT" "file://$HTML" 2>/dev/null

echo "Created $OUTPUT"
