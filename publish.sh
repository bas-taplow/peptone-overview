#!/bin/sh
# Rebuild index.html from the private repo's overview.html, injecting the noindex
# header. overview.html is generated output, so it never carries the tag itself -
# this is the only place it is added, and it must survive every refresh.
set -e
cd "$(dirname "$0")"
python3 - <<'PY'
h = open("../overview.html", encoding="utf-8").read()
tag = ('<meta name="robots" content="noindex,nofollow,noarchive">'
       '<meta name="googlebot" content="noindex,nofollow">')
assert "<head>" in h, "unexpected shape - overview.html has no <head>"
h = h.replace("<head>", "<head>" + tag, 1)
open("index.html", "w", encoding="utf-8").write(h)
print("index.html rebuilt with noindex")
PY
git add -A && git commit -m "Update overview" && git push
