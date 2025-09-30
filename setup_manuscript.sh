#!/bin/bash

# Setup script for GBD2023_DENV manuscript project
# Run this from the repository root directory

set -e  # Exit on error

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}Setting up GBD2023_DENV manuscript structure...${NC}\n"

# Define base directories
MANUSCRIPT_DIR="src/idd_manuscripts/GBD2023_DENV"
NOTEBOOK_DIR="notebooks/GBD2023_DENV"

# Create manuscript directory structure
echo -e "${GREEN}Creating manuscript directories...${NC}"
mkdir -p "${MANUSCRIPT_DIR}/figures"
mkdir -p "${MANUSCRIPT_DIR}/tables"
mkdir -p "${MANUSCRIPT_DIR}/data"

# Create notebook directory structure (for development)
echo -e "${GREEN}Creating notebook directories...${NC}"
mkdir -p "${NOTEBOOK_DIR}"

# Create _quarto.yml
echo -e "${GREEN}Creating _quarto.yml...${NC}"
cat > "${MANUSCRIPT_DIR}/_quarto.yml" << 'EOF'
project:
  type: manuscript

manuscript:
  article: manuscript.qmd
  # Uncomment when ready to include notebooks in final manuscript
  # notebooks:
  #   - notebooks/01_data_loading.qmd
  #   - notebooks/02_figures.qmd
  #   - notebooks/03_tables.qmd
  #   - notebooks/04_text_statistics.qmd
  resources:
    - figures/
    - tables/

bibliography: references.bib
csl: lancet.csl

format:
  docx:
    toc: false
    number-sections: true
  html:
    toc: true
    theme: cosmo

execute:
  echo: false
  warning: false
  message: false
EOF

# Create manuscript.qmd
echo -e "${GREEN}Creating manuscript.qmd...${NC}"
cat > "${MANUSCRIPT_DIR}/manuscript.qmd" << 'EOF'
---
title: "GBD 2023 Dengue Analysis"
author:
  - name: Your Name
    affiliations:
      - name: Institute for Health Metrics and Evaluation
        department: Department Name
        city: Seattle
        state: WA
        country: USA
abstract: |
  Your abstract goes here. This should be a brief summary of your manuscript.
keywords:
  - dengue
  - GBD 2023
  - global health
date: today
---

## Introduction

Your introduction text here.

## Methods

### Data Sources

### Statistical Analysis

## Results

### Main Findings

![Figure 1: Caption here](figures/figure1.png)

## Discussion

## Conclusions

## References {.unnumbered}

::: {#refs}
:::
EOF

# Create empty references.bib
echo -e "${GREEN}Creating references.bib...${NC}"
touch "${MANUSCRIPT_DIR}/references.bib"

# Download Lancet CSL
echo -e "${GREEN}Downloading Lancet citation style...${NC}"
curl -s -o "${MANUSCRIPT_DIR}/lancet.csl" \
  https://raw.githubusercontent.com/citation-style-language/styles/master/the-lancet.csl

# Create template notebooks
echo -e "${GREEN}Creating template notebooks...${NC}"

# 01_data_loading.qmd
cat > "${NOTEBOOK_DIR}/01_data_loading.qmd" << 'EOF'
---
title: "Data Loading and Validation"
author: "Your Name"
date: today
format:
  html:
    code-fold: false
    toc: true
jupyter: python3
---

## Setup

```{python setup}
import pandas as pd
import numpy as np
from pathlib import Path

# Define paths
PROJECT_ROOT = Path.cwd().parent.parent  # Go up to repo root
MANUSCRIPT_DIR = PROJECT_ROOT / "src" / "idd_manuscripts" / "GBD2023_DENV"
DATA_DIR = MANUSCRIPT_DIR / "data"

print(f"Project root: {PROJECT_ROOT}")
print(f"Data directory: {DATA_DIR}")
```

## Load Data

```{python load-data}
# Load your GBD 2023 dengue data here
# data = pd.read_csv(DATA_DIR / "dengue_estimates.csv")

# Example: Create dummy data
data = pd.DataFrame({
    'location': ['Global', 'Southeast Asia', 'Latin America'] * 10,
    'year': list(range(2014, 2024)) * 3,
    'cases': np.random.randint(100000, 500000, 30),
    'deaths': np.random.randint(1000, 5000, 30)
})

print(f"Loaded {len(data)} rows")
data.head()
```

## Data Validation

```{python validate}
# Check for missing values
print("\nMissing values:")
print(data.isnull().sum())

# Check data types
print("\nData types:")
print(data.dtypes)

# Basic statistics
print("\nSummary statistics:")
print(data.describe())
```

## Summary

Data loaded and validated successfully!
EOF

# 02_figures.qmd
cat > "${NOTEBOOK_DIR}/02_figures.qmd" << 'EOF'
---
title: "Figure Generation"
author: "Your Name"
date: today
format:
  html:
    code-fold: false
    toc: true
jupyter: python3
execute:
  cache: true
---

## Setup

```{python setup}
import matplotlib.pyplot as plt
import numpy as np
from pathlib import Path

# Define paths
PROJECT_ROOT = Path.cwd().parent.parent  # Go up to repo root
MANUSCRIPT_DIR = PROJECT_ROOT / "src" / "idd_manuscripts" / "GBD2023_DENV"
FIG_DIR = MANUSCRIPT_DIR / "figures"

# Create figures directory if it doesn't exist
FIG_DIR.mkdir(parents=True, exist_ok=True)

print(f"Saving figures to: {FIG_DIR}")
```

## Figure 1: A Silly Test Figure

```{python figure1}
# Create silly test data
x = np.linspace(0, 10, 100)
y = np.sin(x) * np.exp(-x/10)

# Create figure
fig, ax = plt.subplots(figsize=(8, 6))
ax.plot(x, y, linewidth=3, color='hotpink', label='Dengue trend')
ax.fill_between(x, y, alpha=0.3, color='lightblue')
ax.set_xlabel('Time (arbitrary units)', fontsize=12)
ax.set_ylabel('Dengue Cases (totally made up)', fontsize=12)
ax.set_title('A Very Silly Test Figure 🦟', fontsize=14, fontweight='bold')
ax.legend()
ax.grid(True, alpha=0.3)

# Save figure
fig.savefig(
    FIG_DIR / "figure1.png",
    dpi=300,
    bbox_inches='tight'
)

print("✅ Figure 1 saved!")
plt.show()
```
EOF

# 03_tables.qmd
cat > "${NOTEBOOK_DIR}/03_tables.qmd" << 'EOF'
---
title: "Table Generation"
author: "Your Name"
date: today
format:
  html:
    code-fold: false
    toc: true
jupyter: python3
---

## Setup

```{python setup}
import pandas as pd
import numpy as np
from pathlib import Path

# Define paths
PROJECT_ROOT = Path.cwd().parent.parent  # Go up to repo root
MANUSCRIPT_DIR = PROJECT_ROOT / "src" / "idd_manuscripts" / "GBD2023_DENV"
TABLE_DIR = MANUSCRIPT_DIR / "tables"
DATA_DIR = MANUSCRIPT_DIR / "data"

# Create tables directory if it doesn't exist
TABLE_DIR.mkdir(parents=True, exist_ok=True)

print(f"Saving tables to: {TABLE_DIR}")
```

## Load Data

```{python load-data}
# Load processed data
# data = pd.read_csv(DATA_DIR / "dengue_estimates.csv")
```

## Table 1: Summary Statistics

```{python table1}
# Create silly test table
regions = ['Global', 'Southeast Asia', 'Latin America', 'Sub-Saharan Africa']
cases = [1234567, 456789, 345678, 123456]
deaths = [12345, 4567, 3456, 1234]

table1 = pd.DataFrame({
    'Region': regions,
    'Cases': cases,
    'Deaths': deaths,
    'CFR (%)': np.round(np.array(deaths) / np.array(cases) * 100, 2)
})

# Save as CSV
table1.to_csv(TABLE_DIR / "table1.csv", index=False)

print("✅ Table 1 saved!")

# Display table
table1
```
EOF

# 04_text_statistics.qmd
cat > "${NOTEBOOK_DIR}/04_text_statistics.qmd" << 'EOF'
---
title: "In-Text Statistics"
author: "Your Name"
date: today
format:
  html:
    code-fold: false
    toc: true
jupyter: python3
---

## Setup

```{python setup}
import pandas as pd
import numpy as np
from pathlib import Path

# Define paths
PROJECT_ROOT = Path.cwd().parent.parent  # Go up to repo root
MANUSCRIPT_DIR = PROJECT_ROOT / "src" / "idd_manuscripts" / "GBD2023_DENV"
DATA_DIR = MANUSCRIPT_DIR / "data"

print(f"Loading data from: {DATA_DIR}")
```

## Load Data

```{python load-data}
# Load processed data
# data = pd.read_csv(DATA_DIR / "dengue_estimates.csv")
```

## Key Statistics

Calculate statistics referenced in manuscript text.

```{python key-stats}
# Example silly statistics
global_total = 1_234_567
baseline_year_cases = 500_000
final_year_cases = 1_234_567

percent_change = ((final_year_cases - baseline_year_cases) / baseline_year_cases) * 100

print(f"Global total cases: {global_total:,}")
print(f"Baseline year cases: {baseline_year_cases:,}")
print(f"Final year cases: {final_year_cases:,}")
print(f"Percent change: {percent_change:.1f}%")
```

## Regional Breakdown

```{python regional-stats}
# Regional statistics
regions = {
    'Southeast Asia': 456_789,
    'Latin America': 345_678,
    'Sub-Saharan Africa': 123_456,
    'Other': 308_644
}

for region, cases in regions.items():
    pct = (cases / global_total) * 100
    print(f"{region}: {cases:,} cases ({pct:.1f}%)")
```

## Summary

These statistics can be referenced in your manuscript using inline code or by copying the values.
EOF

# Create README
echo -e "${GREEN}Creating README...${NC}"
cat > "${MANUSCRIPT_DIR}/README.md" << 'EOF'
# GBD 2023 Dengue Manuscript

## Structure

- `manuscript.qmd` - Main manuscript text
- `figures/` - Generated figures for manuscript
- `tables/` - Generated tables for manuscript
- `data/` - Data files used in manuscript
- `references.bib` - Bibliography (exported from Zotero)
- `lancet.csl` - Citation style (Lancet format)

## Development Notebooks

Development notebooks are located in `notebooks/GBD2023_DENV/` (repository root):
- `01_data_loading.qmd` - Data loading and validation
- `02_figures.qmd` - Figure generation
- `03_tables.qmd` - Table generation
- `04_text_statistics.qmd` - In-text statistics

## Workflow

1. Develop analysis in notebooks (in `notebooks/GBD2023_DENV/`)
2. Notebooks save outputs to manuscript folder
3. Reference figures/tables in `manuscript.qmd`
4. When ready to finalize, move notebooks into manuscript folder

## Preview Manuscript

```bash
cd src/idd_manuscripts/GBD2023_DENV
quarto preview manuscript.qmd
```

## Render to Word

```bash
quarto render manuscript.qmd --to docx
```
EOF

# Create .gitignore entry reminder
echo -e "\n${BLUE}Structure created successfully!${NC}\n"

echo -e "${GREEN}Next steps:${NC}"
echo "1. Add to your .gitignore (if not already there):"
echo "   notebooks/"
echo ""
echo "2. Connect your Zotero library:"
echo "   - Export collection as Better BibTeX"
echo "   - Save as: src/idd_manuscripts/GBD2023_DENV/references.bib"
echo ""
echo "3. Start developing in notebooks:"
echo "   cd notebooks/GBD2023_DENV"
echo "   code 01_data_loading.qmd"
echo ""
echo "4. Preview your manuscript:"
echo "   cd src/idd_manuscripts/GBD2023_DENV"
echo "   quarto preview manuscript.qmd"
echo ""
echo -e "${BLUE}Happy writing!${NC}"