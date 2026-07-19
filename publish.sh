#!/bin/sh
# Rebuild the published pages from the private repo's generated output, injecting the
# noindex header. Those files are generated, so they never carry the tag themselves -
# this is the only place it is added, and it must survive every refresh.
#
#   overview.html       -> index.html    the production page
#   overview-fine.html  -> fine.html     the fine-line variant
set -e
cd "$(dirname "$0")"
python3 - <<'PY'
PAGES = (("../overview.html", "index.html"),
         ("../overview-fine.html", "fine.html"))
tag = ('<meta name="robots" content="noindex,nofollow,noarchive">'
       '<meta name="googlebot" content="noindex,nofollow">')
for src, dst in PAGES:
    h = open(src, encoding="utf-8").read()
    assert "<head>" in h, f"unexpected shape - {src} has no <head>"
    assert "noindex" not in h, f"{src} already carries a robots tag"
    open(dst, "w", encoding="utf-8").write(h.replace("<head>", "<head>" + tag, 1))
    print(f"{dst} rebuilt from {src} with noindex")
PY
git add -A && git commit -m "Update overview and fine-line variant" && git push
