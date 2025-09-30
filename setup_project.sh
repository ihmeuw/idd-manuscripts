#!/bin/bash

# Setup script for new analysis project
echo "Setting up analysis pipeline project structure..."

# Create directory structure
mkdir -p .github/workflows
mkdir -p src/idd_manuscripts/{data,analysis,visualization}
mkdir -p docs/{quarto,sphinx}
mkdir -p notebooks/{exploratory,final,templates}
mkdir -p data/{raw,processed,external}
mkdir -p results/{figures,tables,documents}
mkdir -p tests/{test_data,test_analysis,test_visualization}
mkdir -p scripts

# Create __init__.py files
touch src/__init__.py
touch src/idd_manuscripts/__init__.py
touch src/idd_manuscripts/data/__init__.py
touch src/idd_manuscripts/analysis/__init__.py
touch src/idd_manuscripts/visualization/__init__.py
touch tests/__init__.py

# Create basic Python files
cat > src/idd_manuscripts/data/loaders.py << 'EOL'
"""Data loading utilities."""

import pandas as pd
from pathlib import Path


def load_csv(filepath: str) -> pd.DataFrame:
    """Load CSV file with basic error handling."""
    try:
        return pd.read_csv(filepath)
    except FileNotFoundError:
        raise FileNotFoundError(f"Data file not found: {filepath}")
    except Exception as e:
        raise Exception(f"Error loading {filepath}: {str(e)}")
EOL

cat > src/idd_manuscripts/analysis/statistics.py << 'EOL'
"""Statistical analysis functions."""

import pandas as pd
import numpy as np
from typing import Tuple


def basic_summary(df: pd.DataFrame) -> pd.DataFrame:
    """Generate basic summary statistics."""
    return df.describe()


def correlation_analysis(df: pd.DataFrame) -> pd.DataFrame:
    """Calculate correlation matrix for numeric columns."""
    numeric_cols = df.select_dtypes(include=[np.number]).columns
    return df[numeric_cols].corr()
EOL

cat > src/idd_manuscripts/visualization/plots.py << 'EOL'
"""Plotting utilities."""

import matplotlib.pyplot as plt
import seaborn as sns
import pandas as pd
from pathlib import Path


def setup_plot_style():
    """Set up consistent plot styling."""
    plt.style.use('seaborn-v0_8')
    sns.set_palette("husl")


def save_figure(fig, filename: str, output_dir: str = "results/figures"):
    """Save figure with consistent formatting."""
    output_path = Path(output_dir)
    output_path.mkdir(parents=True, exist_ok=True)
    
    fig.savefig(output_path / filename, dpi=300, bbox_inches='tight')
    plt.close(fig)
EOL

cat > scripts/run_analysis.py << 'EOL'
#!/usr/bin/env python3
"""Main analysis pipeline script."""

import sys
from pathlib import Path

# Add src to path so we can import our package
sys.path.insert(0, str(Path(__file__).parent.parent / "src"))

from idd_manuscripts.data.loaders import load_csv
from idd_manuscripts.analysis.statistics import basic_summary
from idd_manuscripts.visualization.plots import setup_plot_style


def main():
    """Run the main analysis pipeline."""
    print("Starting analysis pipeline...")
    
    # Set up plotting
    setup_plot_style()
    
    print("Analysis pipeline completed!")


if __name__ == "__main__":
    main()
EOL

chmod +x scripts/run_analysis.py

echo "Project structure created successfully!"
echo "Next steps:"
echo "1. Create conda environment: conda env create -f environment.yml"
echo "2. Activate environment: conda activate idd-manuscripts"
echo "3. Install package: pip install -e ."
