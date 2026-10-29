#!/usr/bin/env python3

from pathlib import Path
import re

pattern = r"https://doc\.rust-lang\.org/(?:[^/\s\"<>]+/)?(?=(?:std|core|alloc|proc_macro)/)"
for page in Path("target/doc").rglob("*.html"):
    text = page.read_text()
    updated = re.sub(pattern, "http://127.0.0.1:8000/", text)
    if updated != text:
        page.write_text(updated)
