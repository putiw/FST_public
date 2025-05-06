# Functional Map Viewer

This MATLAB-based tool provides functionality for viewing and comparing different functional maps, particularly focused on motion processing areas and visual cortex analysis.

## Overview

The main functionality is provided through the `view_fv` function, which allows visualization and comparison of various functional maps including:
- Motion processing areas (MT+)
- Visual field maps
- Myelin maps
- Population receptive field (pRF) parameters
- Various motion conditions and experimental comparisons

## Usage

The basic usage pattern is:

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
- BIDS-formatted data directory
- Required MATLAB toolboxes (to be specified based on dependencies)

## Data Organization

The tool expects data to be organized in a BIDS-compatible directory structure. The base directory should be specified in the `bidsDir` parameter.

## Notes

- The tool supports comparison of different experimental runs and conditions
- Multiple maps can be compared simultaneously
- Custom combinations of maps can be created based on research needs 