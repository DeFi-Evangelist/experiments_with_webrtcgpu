//
//  FiltersList.swift
//  blitz
//
//  Created by drinkius on 08/08/16.
//  Copyright © 2016 blitz. All rights reserved.
//

import GPUImage
import QuartzCore

let filterOperations: Array<FilterOperationInterface> = [
    FilterOperation(
        filter:{NormalBlend()},
        listName:"Blend Check",
        titleName:"Blend Check",
        sliderConfiguration:.Disabled,
        sliderUpdateCallback: nil,
        filterOperationType:.Blend
    ),
    FilterOperation(
        filter:{BulgeDistortion()},
        listName:"Bulge",
        titleName:"Bulge",
        sliderConfiguration:.Enabled(minimumValue:-1.0, maximumValue:1.0, initialValue:0.5),
        sliderUpdateCallback: {(filter, sliderValue) in
            //            filter.scale = sliderValue
            filter.center = Position(0.5, sliderValue)
        },
        filterOperationType:.SingleInput
    ),
    FilterOperation(
        filter:{FaceTrack()},
        listName:"Face Track",
        titleName:"Face Track",
        sliderConfiguration:.Disabled,
        sliderUpdateCallback: nil,
        filterOperationType:.Own(filterSetupFunction:{(filter) in
            let castFilter = filter as! FaceTrack
            castFilter.center = Position(0.5, 0.1)
//            filter = castFilter
        })
    ),
    FilterOperation(
        filter:{GammaAdjustment()},
        listName:"Gamma",
        titleName:"Gamma",
        sliderConfiguration:.Enabled(minimumValue:0.0, maximumValue:3.0, initialValue:1.0),
        sliderUpdateCallback: {(filter, sliderValue) in
            filter.gamma = sliderValue
        },
        filterOperationType:.SingleInput
    ),
    FilterOperation(
        filter:{AmatorkaFilter()},
        listName:"Amatorka (Lookup)",
        titleName:"Amatorka (Lookup)",
        sliderConfiguration:.Disabled,
        sliderUpdateCallback: nil,
        filterOperationType:.SingleInput
    ),
    FilterOperation(
        filter:{MissEtikateFilter()},
        listName:"Miss Etikate (Lookup)",
        titleName:"Miss Etikate (Lookup)",
        sliderConfiguration:.Disabled,
        sliderUpdateCallback: nil,
        filterOperationType:.SingleInput
    ),
    FilterOperation(
        filter:{Vibrance()},
        listName:"Vibrance",
        titleName:"Vibrance",
        sliderConfiguration:.Enabled(minimumValue:-1.2, maximumValue:1.2, initialValue:0.0),
        sliderUpdateCallback: {(filter, sliderValue) in
            filter.vibrance = sliderValue
        },
        filterOperationType:.SingleInput
    ),
    FilterOperation (
        filter:{HistogramEqualization(type:.RGB)},
        listName:"Histogram equalization",
        titleName:"Histogram Equalization",
        sliderConfiguration:.Disabled,
        sliderUpdateCallback:nil,
        filterOperationType:.SingleInput
    ),
    FilterOperation(
        filter:{AdaptiveThreshold()},
        listName:"Adaptive threshold",
        titleName:"Adaptive Threshold",
        sliderConfiguration:.Enabled(minimumValue:1.0, maximumValue:20.0, initialValue:1.0),
        sliderUpdateCallback: {(filter, sliderValue) in
            filter.blurRadiusInPixels = sliderValue
        },
        filterOperationType:.SingleInput
    ),
    FilterOperation(
        filter:{PolkaDot()},
        listName:"Polka dot",
        titleName:"Polka Dot",
        sliderConfiguration:.Enabled(minimumValue:0.0, maximumValue:0.3, initialValue:0.05),
        sliderUpdateCallback: {(filter, sliderValue) in
            filter.fractionalWidthOfAPixel = sliderValue
        },
        filterOperationType:.SingleInput
    ),
    FilterOperation(
        filter:{Halftone()},
        listName:"Halftone",
        titleName:"Halftone",
        sliderConfiguration:.Enabled(minimumValue:0.0, maximumValue:0.05, initialValue:0.01),
        sliderUpdateCallback: {(filter, sliderValue) in
            filter.fractionalWidthOfAPixel = sliderValue
        },
        filterOperationType:.SingleInput
    ),
    FilterOperation(
        filter:{SobelEdgeDetection()},
        listName:"Sobel edge detection",
        titleName:"Sobel Edge Detection",
        sliderConfiguration:.Enabled(minimumValue:0.0, maximumValue:1.0, initialValue:0.25),
        sliderUpdateCallback: {(filter, sliderValue) in
            filter.edgeStrength = sliderValue
        },
        filterOperationType:.SingleInput
    ),
    FilterOperation(
        filter:{PrewittEdgeDetection()},
        listName:"Prewitt edge detection",
        titleName:"Prewitt Edge Detection",
        sliderConfiguration:.Enabled(minimumValue:0.0, maximumValue:1.0, initialValue:1.0),
        sliderUpdateCallback: {(filter, sliderValue) in
            filter.edgeStrength = sliderValue
        },
        filterOperationType:.SingleInput
    ),
    FilterOperation(
        filter:{ThresholdSketchFilter()},
        listName:"Threshold Sketch",
        titleName:"Threshold Sketch",
        sliderConfiguration:.Enabled(minimumValue:0.0, maximumValue:1.0, initialValue:0.25),
        sliderUpdateCallback: {(filter, sliderValue) in
            filter.threshold = sliderValue
        },
        filterOperationType:.SingleInput
    ),
    FilterOperation(
        filter:{Vignette()},
        listName:"Vignette",
        titleName:"Vignette",
        sliderConfiguration:.Enabled(minimumValue:0.5, maximumValue:0.9, initialValue:0.75),
        sliderUpdateCallback: {(filter, sliderValue) in
            filter.end = sliderValue
        },
        filterOperationType:.SingleInput
    ),
    FilterOperation(
        filter:{GaussianBlur()},
        listName:"Gaussian blur",
        titleName:"Gaussian Blur",
        sliderConfiguration:.Enabled(minimumValue:0.0, maximumValue:40.0, initialValue:2.0),
        sliderUpdateCallback: {(filter, sliderValue) in
            filter.blurRadiusInPixels = sliderValue
        },
        filterOperationType:.SingleInput
    ),
    FilterOperation(
        filter:{ZoomBlur()},
        listName:"Zoom blur",
        titleName:"Zoom Blur",
        sliderConfiguration:.Enabled(minimumValue:0.0, maximumValue:2.5, initialValue:1.0),
        sliderUpdateCallback: {(filter, sliderValue) in
            filter.blurSize = sliderValue
        },
        filterOperationType:.SingleInput
    ),
    FilterOperation(
        filter:{PinchDistortion()},
        listName:"Pinch",
        titleName:"Pinch",
        sliderConfiguration:.Enabled(minimumValue:-2.0, maximumValue:2.0, initialValue:0.5),
        sliderUpdateCallback: {(filter, sliderValue) in
            filter.scale = sliderValue
        },
        filterOperationType:.SingleInput
    ),
    FilterOperation(
        filter:{LocalBinaryPattern()},
        listName:"Local binary pattern",
        titleName:"Local Binary Pattern",
        sliderConfiguration:.Disabled,
        sliderUpdateCallback:nil,
        filterOperationType:.SingleInput
    ),
    FilterOperation(
        filter:{ChromaKeyBlend()},
        listName:"Chroma key blend (green)",
        titleName:"Chroma Key (Green)",
        sliderConfiguration:.Enabled(minimumValue:0.0, maximumValue:1.0, initialValue:0.4),
        sliderUpdateCallback: {(filter, sliderValue) in
            filter.thresholdSensitivity = sliderValue
        },
        filterOperationType:.Blend
    ),
]