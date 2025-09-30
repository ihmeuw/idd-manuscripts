#!/bin/bash

cat > notebooks/GBD2023_DENV/00_references.qmd << 'EOF'
---
title: "Reference Management"
author: "Your Name"
date: today
format:
  html:
    code-fold: false
    toc: true
jupyter: python3
---

## Setup

```{python}
import sys
from pathlib import Path
import json

# Setup paths
PROJECT_ROOT = Path.cwd().parent.parent
sys.path.insert(0, str(PROJECT_ROOT / "src"))
MANUSCRIPT_DIR = PROJECT_ROOT / "src" / "idd_manuscripts" / "GBD2023_DENV"
CACHE_FILE = Path.cwd() / "zotero_cache.json"

from idd_manuscripts import constants as rfc
from idd_manuscripts.bibliography import (
    search_bibliography, 
    fetch_zotero_items,
    fetch_zotero_bibtex
)

print(f"Manuscript folder: {MANUSCRIPT_DIR}")
```

## Update Full Bibliography

Run this to fetch your entire Zotero library and save to references.bib

```{python}
#| eval: false
user_id = rfc.zotero_config['username']
api_key = rfc.zotero_config['api_key']
bib_path = MANUSCRIPT_DIR / "references.bib"

fetch_zotero_bibtex(user_id, api_key, str(bib_path))
print(f"✅ Bibliography saved to: {bib_path}")
```

## Load Zotero Items (for searching)

```{python}
# Load from cache if exists, otherwise fetch from API
if CACHE_FILE.exists():
    print("Loading from cache...")
    with open(CACHE_FILE, 'r') as f:
        items = json.load(f)
else:
    print("Fetching from Zotero API (this may take a minute)...")
    user_id = rfc.zotero_config['username']
    api_key = rfc.zotero_config['api_key']
    items = fetch_zotero_items(user_id, api_key)
    with open(CACHE_FILE, 'w') as f:
        json.dump(items, f)
    print(f"✅ Cached {len(items)} items")

print(f"Loaded {len(items)} items from Zotero")
```

## Search Examples

### Example 1: Find dengue papers

```{python}
search_bibliography(items, title_words=['dengue'])
```

### Example 2: Find recent papers in The Lancet

```{python}
search_bibliography(items, journal='lancet', year_range=(2020, 2024))
```

## Refresh Cache

Uncomment and run this cell to force refresh from Zotero API:

```{python}
#| eval: false
CACHE_FILE.unlink()
print("Cache deleted. Re-run 'Load Zotero Items' cell to refresh.")
```
EOF

echo "✅ Created 00_references.qmd"