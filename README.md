# Functional Map Viewer and Analysis Tools

This MATLAB-based toolkit provides functionality for viewing, analyzing, and comparing different functional maps, particularly focused on motion processing areas and visual cortex analysis.

## Main Components

The toolkit consists of three main components:

1. **Run Analysis (`run_all.m`)**: Data processing and analysis pipeline
2. **Statistical Analysis (`run_stats.m`)**: Statistical testing and group analysis
3. **View Maps (`view_fv`)**: Visualization tool for functional maps

## 1. Run Analysis (`run_all.m`)

The `run_all.m` script handles the main data processing pipeline, including:
- Loading and preprocessing fMRI data
- Computing beta weights for different conditions
- Processing task-specific data (motion, hand, transparent motion, etc.)
- Saving results in MGZ format

### Key Features
- Supports multiple task types (motion, hand, transparent motion, etc.)
- Handles design matrix creation and HRF convolution
- Processes noise regressors and motion parameters
- Saves results in FreeSurfer-compatible format

## 2. Statistical Analysis (`run_stats.m`)

The `run_stats.m` script performs statistical analysis across subjects, including:
- Group-level statistical testing
- Comparison of different conditions
- Visualization of statistical results
- Analysis of hemispheric differences

### Features
- Supports multiple statistical tests (t-tests, correlations)
- Handles both individual subject and group-level analysis
- Provides visualization tools for statistical results
- Supports analysis of different ROIs and conditions

## 3. View Maps (`view_fv`)

The main visualization functionality is provided through the `view_fv` function, which allows visualization and comparison of various functional maps including:
- Motion processing areas (MT+)
- Visual field maps
- Myelin maps
- Population receptive field (pRF) parameters
- Various motion conditions and experimental comparisons

### Usage

```matlab
view_fv(subject, bidsDir, map1, map2, ...)
```

### Parameters
- `subject`: Subject identifier (e.g., 'sub-0037')
- `bidsDir`: Path to BIDS-formatted data directory
- `map1, map2, ...`: Maps to compare/visualize

### Example Comparisons

The tool supports various types of comparisons:

1. Motion Conditions:
```matlab
view_fv(sub, bidsDir, 'out', 'in', 'cw', 'ccw');
```

2. Visual Field Maps:
```matlab
view_fv(sub, bidsDir, 'l', 'upper', 'lower', 'prfvista_mov/angle_adj');
```

3. PRF Parameters:
```matlab
view_fv(sub, bidsDir, 'angle_adj', 'eccen', 'sigma');
```

4. Myelin Maps:
```matlab
view_fv(sub, bidsDir, 'SmoothedMyelinMap_BC', 'mt+2');
```

## Available Maps

The tool supports visualization of various map types:
- Motion processing: 'mt+1', 'mt+2'
- Visual field: 'l', 'upper', 'lower'
- PRF parameters: 'angle_adj', 'eccen', 'sigma'
- Myelin maps: 'SmoothedMyelinMap_BC', 'MyelinMap_BC'
- Motion conditions: 'oppo2', 'oppo3', 'cd1', 'cd2'

## Requirements

- MATLAB
- FreeSurfer
- BIDS-formatted data directory
- Required MATLAB toolboxes:
  - GLMdenoise
  - nsdcode
  - vistasoft
  - cvncode
  - knkutils
  - gifti
  - GLMsingle

## Data Organization

The tool expects data to be organized in a BIDS-compatible directory structure. The base directory should be specified in the `bidsDir` parameter.

## Notes

- The tool supports comparison of different experimental runs and conditions
- Multiple maps can be compared simultaneously
- Custom combinations of maps can be created based on research needs
- Statistical analysis can be performed at both individual and group levels 