#!/usr/bin/env bash
# Usage: ./export-pdf.sh [input.md]  -> writes input.pdf next to it
set -euo pipefail

cd "$(dirname "$0")"
FONTS="file://$PWD/fonts"
INPUT="${1:-resume-2026.md}"
OUTPUT="${INPUT%.md}.pdf"
HTML="$(mktemp -t resume).html"
CHROME="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"

BODY="$(npx -y marked@12 -i "$INPUT")"

cat > "$HTML" <<EOF
<!doctype html>
<html><head><meta charset="utf-8">
<style>
  @font-face { font-family: "Inter"; font-style: normal; font-weight: 100 900;
               src: url("$FONTS/InterVariable.ttf"); }
  @font-face { font-family: "Inter"; font-style: italic; font-weight: 100 900;
               src: url("$FONTS/InterVariable-Italic.ttf"); }
  @page { size: A4; margin: 12mm 14mm; }
  body { font-family: "Inter", -apple-system, "Helvetica Neue", Arial, sans-serif;
         font-size: 9pt; line-height: 1.32; color: #111; }
  h1 { font-size: 20pt; font-weight: 700; letter-spacing: -.3px; margin: 0 0 2px; }
  strong { font-weight: 600; }
  h2 { font-size: 12pt; margin: 14px 0 4px; text-transform: uppercase;
       letter-spacing: .5px; border-bottom: 1px solid #ccc; padding-bottom: 2px; }
  h3 { font-size: 10.5pt; margin: 10px 0 0; }
  p { margin: 3px 0; }
  ul { margin: 3px 0; padding-left: 16px; }
  li { margin: 1px 0; }
  hr { display: none; }
  a { color: #0a58ca; text-decoration: underline; text-underline-offset: 2px; }
  h3, h3 + p { break-after: avoid; }
  li { break-inside: avoid; }
</style></head>
<body>$BODY</body></html>
EOF

"$CHROME" --headless --disable-gpu --no-pdf-header-footer --allow-file-access-from-files \
  --print-to-pdf="$PWD/$OUTPUT" "file://$HTML" 2>/dev/null

echo "Created $OUTPUT"
