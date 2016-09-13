public class FaceTrack: BasicOperation {
    
//    public var center:Position = Position.Center { didSet { uniformSettings["center"] = center } }
//    
//    public init() {
//        super.init(fragmentShader:NormalBlendFragmentShader, numberOfInputs:2)
//        ({center = Position.Center})()
//    }
    
    public var radius:Float = 0.25 { didSet { uniformSettings["radius"] = radius } }
    public var scale:Float = 0.5 { didSet { uniformSettings["scale"] = scale } }
    public var center:Position = Position.Center { didSet { uniformSettings["center"] = center } }
    
    public init() {
        super.init(fragmentShader:BulgeDistortionFragmentShader, numberOfInputs:1)
        
        ({radius = 0.25})()
        ({scale = 0.8})()
        ({center = Position.Center})()
    }
    
}

public let FaceTrackShader = try! String(contentsOfFile: NSBundle.mainBundle().pathForResource("FaceTrack", ofType: "cikernel")!, encoding: NSUTF8StringEncoding)

//public let FaceTrackShader = "varying highp vec2 textureCoordinate;\n varying highp vec2 textureCoordinate2;\n \n uniform sampler2D inputImageTexture;\n uniform sampler2D inputImageTexture2;\n \n void main()\n {\n  mediump vec4 base = texture2D(inputImageTexture, textureCoordinate);\n  mediump vec4 overlay = texture2D(inputImageTexture2, textureCoordinate2);\n   \n   mediump float ra;\n   if (overlay.a == 0.0 || ((base.r / overlay.r) > (base.a / overlay.a)))\n     ra = overlay.a * base.a + overlay.r * (1.0 - base.a) + base.r * (1.0 - overlay.a);\n   else\n     ra = (base.r * overlay.a * overlay.a) / overlay.r + overlay.r * (1.0 - base.a) + base.r * (1.0 - overlay.a);\n   \n \n   mediump float ga;\n   if (overlay.a == 0.0 || ((base.g / overlay.g) > (base.a / overlay.a)))\n     ga = overlay.a * base.a + overlay.g * (1.0 - base.a) + base.g * (1.0 - overlay.a);\n   else\n     ga = (base.g * overlay.a * overlay.a) / overlay.g + overlay.g * (1.0 - base.a) + base.g * (1.0 - overlay.a);\n \n   \n   mediump float ba;\n   if (overlay.a == 0.0 || ((base.b / overlay.b) > (base.a / overlay.a)))\n     ba = overlay.a * base.a + overlay.b * (1.0 - base.a) + base.b * (1.0 - overlay.a);\n   else\n     ba = (base.b * overlay.a * overlay.a) / overlay.b + overlay.b * (1.0 - base.a) + base.b * (1.0 - overlay.a);\n \n   mediump float a = overlay.a + base.a - overlay.a * base.a;\n   \n  gl_FragColor = vec4(ra, ga, ba, a);\n }\n "


//public class BulgeDistortion2: BasicOperation {
//    public var radius:Float = 0.25 { didSet { uniformSettings["radius"] = radius } }
//    public var scale:Float = 0.5 { didSet { uniformSettings["scale"] = scale } }
//    public var center:Position = Position.Center { didSet { uniformSettings["center"] = center } }
//    
//    public init() {
//        super.init(fragmentShader:BulgeDistortionFragmentShader, numberOfInputs:1)
//        
//        ({radius = 0.25})()
//        ({scale = 0.5})()
//        ({center = Position.Center})()
//    }
//}

//FilterOperation(
//    filter:{MonochromeFilter()},
//    listName:"Monochrome",
//    titleName:"Monochrome",
//    sliderConfiguration:.Enabled(minimumValue:0.0, maximumValue:1.0, initialValue:1.0),
//    sliderUpdateCallback: {(filter, sliderValue) in
//        filter.intensity = sliderValue
//    },
//    filterOperationType:.Custom(filterSetupFunction:{(camera, filter, outputView) in
//        let castFilter = filter as! MonochromeFilter
//        camera --> castFilter --> outputView
//        castFilter.color = Color(red:0.0, green:0.0, blue:1.0, alpha:1.0)
//        return nil
//    })
//),

// Cut and reposition kernel
//kernel vec4 coreImageKernel(sampler image, float minX, float maxX, float shift)
//{
//    vec2 coord = samplerCoord( image );
//    
//    float x = coord.x;
//    float inRange = compare( minX - x, compare( x - maxX, 1., 0. ), 0. );
//    coord.x = coord.x + inRange * shift;
//    return sample( image, coord );
//}


// Initial 

//public class FaceTrack: BasicOperation {
//    
//    public var center:Position = Position.Center { didSet { uniformSettings["center"] = center } }
//    
//    public init() {
//        super.init(fragmentShader:FaceTrackShader, numberOfInputs:2)
//        ({center = Position.Center})()
//    }
//}