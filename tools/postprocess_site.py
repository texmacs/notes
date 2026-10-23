#!/usr/bin/env python3
"""Finish TeXmacs' static HTML export of the notes website.

TeXmacs emits conservative XHTML with the same <title> on every page and no
page metadata.  This pass gives each page in docs/ a modern HTML head (title,
description, viewport, canonical URL, feed discovery) and image attributes,
and writes the root index.html, 404.html and sitemap.xml.

It is idempotent, so it can run after every incremental export.  With --check
it writes nothing and fails if any output is out of date.
"""

from __future__ import annotations

import argparse
from html import unescape
from pathlib import Path
import re
import sys
from urllib.parse import unquote, urlsplit


ROOT = Path(__file__).resolve().parents[1]
DOCS = ROOT / "docs"
SITE_URL = "https://texmacs.github.io/notes"
SITE_NAME = "Notes on TeXmacs"
FEED_URL = f"{SITE_URL}/docs/notes.atom"

ALT_TEXT = {
    "texmacs-blog-transparent.png": "Notes on TeXmacs logo",
}

TAG_TEXT = re.compile(r"<[^>]+>")
H1 = re.compile(r"<h1\b[^>]*>(.*?)</h1>", re.I | re.S)
ABSTRACT = re.compile(
    r'<div\b[^>]*class="[^"]*\bnotes-abstract\b[^"]*"[^>]*>(.*?)</div>',
    re.I | re.S,
)
IMAGE = re.compile(r"<img\b[^>]*>", re.I)


def plain_text(fragment: str) -> str:
    value = TAG_TEXT.sub(" ", fragment)
    value = unescape(value).replace("\xa0", " ")
    value = " ".join(value.split())
    # TeXmacs renders "..." and similar as characters separated by spacers.
    return re.sub(r" ([.,;:!?)])", r"\1", value)


def escape_attribute(value: str) -> str:
    return (
        value.replace("&", "&amp;")
        .replace('"', "&quot;")
        .replace("<", "&lt;")
        .replace(">", "&gt;")
    )


def page_title(text: str, relative: str) -> str:
    for match in H1.finditer(text):
        title = plain_text(match.group(1))
        if title:
            return title
    return Path(relative).stem.replace("-", " ").capitalize()


def description(text: str, title: str, relative: str) -> str:
    if relative == "main.html":
        return (
            "A blog/wiki about GNU TeXmacs: articles, snippets, developer "
            "notes and proposals by the TeXmacs community."
        )
    match = ABSTRACT.search(text)
    if match:
        value = plain_text(match.group(1))
        if value:
            if len(value) > 300:
                value = value[:297].rsplit(" ", 1)[0] + "..."
            return value
    return f"{title}, an article on {SITE_NAME}."


def canonical_url(relative: str) -> str:
    return f"{SITE_URL}/docs/{relative}"


def modernize_head(text: str, relative: str, title: str) -> str:
    text = re.sub(r"^<\?xml[^>]*>\s*", "", text, count=1, flags=re.I)
    text = re.sub(r"<!DOCTYPE[^>]*>", "<!doctype html>", text, count=1, flags=re.I)
    text = re.sub(r"<html\b[^>]*>", '<html lang="en">', text, count=1, flags=re.I)

    # Remove metadata created by TeXmacs or an earlier pass, then recreate it.
    text = re.sub(r'\s*<meta\b(?=[^>]*\bcharset=)[^>]*>(?:</meta>)?', "", text, flags=re.I)
    text = re.sub(
        r'\s*<meta\b(?=[^>]*\bname="(?:generator|viewport|description)")[^>]*>(?:</meta>)?',
        "",
        text,
        flags=re.I,
    )
    text = re.sub(r'\s*<link\b(?=[^>]*\brel="canonical")[^>]*>(?:</link>)?', "", text, flags=re.I)
    text = re.sub(
        r'\s*<link\b(?=[^>]*\brel="alternate")(?=[^>]*\btype="application/atom\+xml")[^>]*>(?:</link>)?',
        "",
        text,
        flags=re.I,
    )
    text = text.replace(
        "<head>",
        '<head>\n    <meta charset="utf-8">\n    <meta name="generator" content="TeXmacs">',
        1,
    )

    display_title = title if relative == "main.html" else f"{title} — {SITE_NAME}"
    text = re.sub(
        r"<title>.*?</title>",
        lambda _match: f"<title>{escape_attribute(display_title)}</title>",
        text,
        count=1,
        flags=re.I | re.S,
    )
    metadata = (
        '    <meta name="viewport" content="width=device-width, initial-scale=1">\n'
        f'    <meta name="description" content="{escape_attribute(description(text, title, relative))}">\n'
        f'    <link rel="canonical" href="{canonical_url(relative)}">\n'
        f'    <link rel="alternate" type="application/atom+xml" title="{SITE_NAME}" href="{FEED_URL}">\n'
    )
    text = text.replace("  </head>", metadata + "  </head>", 1)
    text = re.sub(r'\s+language="javascript"', "", text, flags=re.I)
    # End tags of void elements are invalid in HTML.
    return re.sub(r"</(?:meta|link|img|hr)>", "", text, flags=re.I)


def modernize_images(text: str, title: str) -> str:
    def replace(match: re.Match[str]) -> str:
        tag = match.group(0)
        src_match = re.search(r'\bsrc="([^"]+)"', tag, re.I)
        src = unquote(urlsplit(src_match.group(1)).path) if src_match else ""
        alt = ALT_TEXT.get(Path(src).name, f"Figure from “{title}”")
        if not re.search(r"\balt=", tag, re.I):
            tag = tag[:-1] + f' alt="{escape_attribute(alt)}">'
        if not re.search(r"\bdecoding=", tag, re.I):
            tag = tag[:-1] + ' decoding="async">'
        if not re.search(r"\bloading=", tag, re.I):
            tag = tag[:-1] + ' loading="lazy">'
        return tag

    return IMAGE.sub(replace, text)


def anchor_footnotes(text: str) -> str:
    # TeXmacs links each footnote mark to #footnote-N but does not give the
    # footnote itself that id.
    count = 0

    def replace(match: re.Match[str]) -> str:
        nonlocal count
        count += 1
        anchor = f"footnote-{count}"
        if f'id="{anchor}"' in text:
            return match.group(0)
        return f'<div class="footnote" id="{anchor}">'

    return re.sub(r'<div class="footnote">', replace, text)


def transform(path: Path) -> str:
    relative = path.relative_to(DOCS).as_posix()
    text = path.read_bytes().decode("utf-8")
    title = page_title(text, relative)
    text = modernize_head(text, relative, title)
    text = modernize_images(text, title)
    text = anchor_footnotes(text)
    return re.sub(r"[ \t]+(?=\n)", "", text)


def root_index() -> str:
    target = "docs/main.html"
    return f"""<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>{SITE_NAME}</title>
    <link rel="canonical" href="{canonical_url("main.html")}">
    <meta http-equiv="refresh" content="0; url={target}">
  </head>
  <body>
    <p><a href="{target}">{SITE_NAME}</a></p>
  </body>
</html>
"""


def not_found_page() -> str:
    return f"""<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="robots" content="noindex">
    <title>Page not found — {SITE_NAME}</title>
    <link rel="stylesheet" href="/notes/resources/notes-base.css">
    <link rel="icon" href="/notes/resources/blog-icon.png">
  </head>
  <body>
    <h1>Page not found</h1>
    <p>The requested page is not available. See the
    <a href="/notes/docs/main.html">main page</a> or the
    <a href="/notes/docs/list-articles.html">list of all the articles</a>.</p>
  </body>
</html>
"""


def sitemap(pages: list[Path]) -> str:
    body = "\n".join(
        f"  <url><loc>{canonical_url(path.relative_to(DOCS).as_posix())}</loc></url>"
        for path in sorted(pages)
    )
    return (
        '<?xml version="1.0" encoding="UTF-8"?>\n'
        '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">\n'
        f"{body}\n</urlset>\n"
    )


def expected_outputs() -> dict[Path, bytes]:
    pages = sorted(DOCS.rglob("*.html"))
    outputs = {path: transform(path).encode("utf-8") for path in pages}
    outputs[ROOT / "index.html"] = root_index().encode("utf-8")
    outputs[ROOT / "404.html"] = not_found_page().encode("utf-8")
    outputs[ROOT / "sitemap.xml"] = sitemap(pages).encode("utf-8")
    return outputs


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--check", action="store_true", help="report stale output without writing")
    args = parser.parse_args()

    outputs = expected_outputs()
    changed = [path for path, content in outputs.items() if not path.exists() or path.read_bytes() != content]
    if args.check:
        for path in changed:
            print(f"out of date: {path.relative_to(ROOT)}")
        return 1 if changed else 0

    for path in changed:
        path.write_bytes(outputs[path])
    print(f"Post-processed {len(outputs)} files ({len(changed)} changed).")
    return 0


if __name__ == "__main__":
    sys.exit(main())
